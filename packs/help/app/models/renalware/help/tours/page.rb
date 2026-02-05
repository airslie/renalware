module Renalware
  module Help
    module Tours
      class Page < ApplicationRecord
        validates :route, presence: true, uniqueness: { case_sensitive: false }
        has_many :annotations, dependent: :destroy
        EMPTY_JSON = "{}".freeze

        def self.for_route(route)
          includes(:annotations)
            .order(annotations: { position: :asc })
            .find_by(route: route)
        end

        def self.json_for(request)
          route = route_for(request)
          return EMPTY_JSON if route.blank?

          Rails.cache.fetch(route, **cache_options) do
            for_route(route)&.to_json || EMPTY_JSON
          end
        end

        def self.cache_expiry_seconds = Renalware.config.help_tours_page_cache_expiry_seconds

        def self.route_for(request)
          route = request&.route_uri_pattern || ""
          route.split("(").first
        end

        def self.cache_options
          {
            expires_in: cache_expiry_seconds.seconds,
            namespace: "help_tours"
          }
        end

        def to_json(_options = {})
          {
            id: id,
            route: route,
            annotations: annotations.map(&:to_json)
          }.to_json
        end
      end
    end
  end
end
