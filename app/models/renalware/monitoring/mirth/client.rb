module Renalware
  module Monitoring
    module Mirth
      class Client
        def channel_stats         = connection.get("channels/statistics")
        def channel_ids_and_names = connection.get("channels/idsAndNames")
        def channel_groups        = connection.get("channels/channelgroups?1")

        private

        def connection
          Faraday.new(
            url: base_url,
            headers: {
              "Cache-Control" => "no-cache",
              accept: "application/xml",
              "X-Requested-With" => "OpenAPI"
            },
            ssl: ssl_options
          ) do |f|
            f.request :authorization, :basic, api_username, api_password
            f.response :raise_error, include_request: true, allowed_statuses: [200]
          end
        end

        def base_url      = Renalware.config.monitoring_mirth_api_base_url
        def api_username  = Renalware.config.monitoring_mirth_api_username
        def api_password  = Renalware.config.monitoring_mirth_api_password
        def ssl_options   = { verify: false }
      end
    end
  end
end
