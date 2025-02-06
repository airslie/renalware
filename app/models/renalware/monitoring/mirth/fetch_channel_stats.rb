module Renalware
  module Monitoring
    module Mirth
      class FetchChannelStats
        include Callable

        # loop though the channel uuids and names and save to the database if changed
        def call # rubocop:disable Metrics/MethodLength
          System::APILog.with_log("Renalware::Monitoring::Mirth::FetchChannelStats") do
            channel_stats.xpath("//channelStatistics").each do |node|
              channel_uuid = node.xpath("channelId").text
              ChannelStats.create!(
                channel_id: channel_hash.fetch(channel_uuid).fetch(:active_record_id),
                received: node.xpath("received").text,
                sent: node.xpath("sent").text,
                error: node.xpath("error").text,
                queued: node.xpath("queued").text,
                filtered: node.xpath("filtered").text
              )
            end
          end
        end

        private

        def channel_hash
          @channel_hash ||= begin
            entries = channel_ids_and_names.xpath("/map/entry")
            entries.each_with_object({}) do |entry, hash|
              uuid = entry.xpath("string")[0].text
              name = entry.xpath("string")[1].text
              channel = Channel.find_or_create_by!(uuid: uuid) { |ch| ch.name = name }
              hash[uuid] = {
                name: entry.xpath("string")[1].text,
                active_record_id: channel.id
              }
            end
          end
        end

        def client        = Client.new
        def groups        = Nokogiri.XML(client.channel_groups.body)
        def channel_stats = Nokogiri.XML(client.channel_stats.body)
        def channel_ids_and_names = Nokogiri.XML(client.channel_ids_and_names.body)
      end
    end
  end
end
