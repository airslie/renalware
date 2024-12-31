require_relative "../../app/models/concerns/renalware/callable"

namespace :feeds do
  task fake_data: :environment do
    return if Rails.env.production?

    100.times {
      Renalware::GenerateTestFeedMessages.call(patient_count: 1000, feed_message_count: 100000)
    }
  end
end

module Renalware
  class GenerateTestFeedMessages
    include Callable
    pattr_initialize [patient_count: 100, feed_message_count: 100]

    def call
      patients = create_patients
      create_feed_message(patients)
    end

    def user = @user ||= SystemUser.find
    def sex = %w(M F).sample
    def dob = Time.zone.today - rand(30000) + 100
    def nhs_number = nhs_numbers.sample
    def guid = SecureRandom::uuid
    def username = "#{Faker::Creature::Animal.name}#{Time.zone.now.to_i}"
    def message_types = %i(ORU ADT)
    def adt_event_types = %i(A28 A31 A05)
    def orc_order_statuses = @orc_order_statuses ||= %w(A A CM)

    def nhs_numbers
      @nhs_numbers ||= CSV.foreach(
        Engine.root.join("doc/example_nhs_numbers.txt"),
        headers: false
      ).flat_map { |row| row.first }
    end

    def create_patients
      patients = (1..patient_count).flat_map do |_idx|
        {
          family_name: Faker::Name.last_name,
          given_name: Faker::Name.first_name,
          nhs_number: nhs_number,
          created_by_id: user.id,
          updated_by_id: user.id,
          born_on: dob,
          sex: sex,
          local_patient_id: guid,
          local_patient_id_2: guid,
          local_patient_id_3: guid,
          local_patient_id_4: guid,
          local_patient_id_5: guid,
          secure_id: guid
        }
      end
      ids = Patient.upsert_all(patients, unique_by: :secure_id)
      # ids.map { |x| x["id"] }
      patients
    end

    def create_feed_message(patients)
      batches = 10
      batch_size = feed_message_count / 10
      (1..batches).each do |idx_batch|
        msgs = (1..batch_size).each.flat_map do |idx|
          patient = patients.sample
          x = guid
          {
            local_patient_id: patient[:local_patient_id],
            local_patient_id_2: patient[:local_patient_id_2],
            local_patient_id_3: patient[:local_patient_id_3],
            local_patient_id_4: patient[:local_patient_id_4],
            local_patient_id_5: patient[:local_patient_id_5],
            dob: patient[:born_on],
            nhs_number: patient[:nhs_number],
            header_id: "#{idx_batch}-#{idx}",
            body: "#{idx_batch}-#{idx}",
            body_hash: x,
            message_type: "ORU",
            event_type: "R01",
            orc_order_status: orc_order_statuses.sample,
            orc_filler_order_number: x
          }
        end
        Feeds::Message.upsert_all(msgs, unique_by: :body_hash)
      end
    end
  end
end
