namespace :pathology do
  namespace :test do
    desc "In development only, import a test HL7 message. Useful for testing listeners."
    task import_one: :environment do
      raise NotImplementedError unless Rails.env.development?

      # Load the example HL7 file.
      path = Renalware::Engine.root.join("app", "jobs", "hl7_message_example.yml")
      raw_message = File.read(path)

      # It has a struct header at the top so it can also be dumped into
      # the delayed_job queue, but we want to skip queuing so strip out that header and simulate
      # the message being passed directly to the FeedJob which will persist and process the message.
      raw_message = raw_message.gsub("--- !ruby/struct:FeedJob\n", "")

      # Replace the MSH date with now() to guarantee a unique message. not doing so results in
      # an index violation because we calc am MD5 hash of the message and this has to be unique -
      # this prevents us importing the same message twice.
      raw_message = raw_message.gsub("20091112164645", Time.zone.now.strftime("%Y%m%d%H%M%S"))

      # Load the message into a hash as delayed_Job would do and splat the hash keys as keyword args
      # into the FeedJob ctor.
      hash = YAML.safe_load(*raw_message).symbolize_keys
      Delayed::Job.enqueue FeedJob.new(hash[:raw_message])
    end

    desc "In development only, enqueue a test HL7 message"
    task enqueue_one: :environment do
      raise NotImplementedError unless Rails.env.development?

      # Load the example HL7 file.
      path = Renalware::Engine.root.join("app", "jobs", "hl7_message_example.txt")
      raw_message = File.read(path)

      # Make sure line endings are \r and not \n or as that is how the HL7 looks
      raw_message = raw_message.tr "\n", "\r"

      # To do this in a loop be sure to add .L ms when gsub-ing the msg
      # 10000.times do
      raw_msg = raw_message.dup
      # Replace the MSH date with now() to guarantee a unique message. not doing so results in
      # an index violation because we calc am MD5 hash of the message and this has to be unique -
      # this prevents us importing the same message twice.
      # raw_msg = raw_msg.gsub("20091112164645", Time.zone.now.strftime("%Y%m%d%H%M%S.%L"))
      raw_msg = raw_msg.gsub("20091112164645", Time.zone.now.strftime("%Y%m%d%H%M%S"))

      sql = if Renalware.config.process_hl7_via_raw_messages_table
              "select renalware.insert_raw_hl7_message('#{raw_msg}'::text);"
            else
              "select renalware.new_hl7_message('#{raw_msg}'::text);"
            end

      ActiveRecord::Base.connection.execute(sql)
    end
  end

  desc "Reprocess feed_messages from a point in time - for testing and assumes pathology " \
       "request/observation tables have been cleared back to that point as data will be " \
       "duplicated otherwise"
  task reprocess_feed_messages: :environment do
    reprocess_from = Time.zone.parse(ENV.fetch("reprocess_from"))
    message_type = ENV.fetch("message_type", :ORU)

    unless reprocess_from
      raise ArgumentError, "pass a valid datetime string eg '2029-01-01 12:01:01'"
    end

    puts "Reprocessing from #{reprocess_from}"

    Renalware::Feeds::Message
      .where(message_type: message_type)
      .where("created_at >= ?", reprocess_from)
      .order(created_at: :asc)
      .select(:id)
      .find_each(batch_size: 1000) do |msg|
        Renalware::Pathology::ReprocessFeedMessageJob.perform_later(message: msg)
      end
  end

  desc "Derive and store missing URR pathology. At some sites the URR arrives via the lab, " \
       "at others we need to generate it"
  task generate_missing_urr: :environment do
    Renalware::Pathology::Generators::UrrGenerator.call
  end
end
