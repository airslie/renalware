module Renalware
  module Medications
    class Provider
      PROVIDERS = [
        ["GP", :gp],
        ["Hospital", :hospital, data: { default_for: :hd }],
        ["Home Delivery", :home_delivery]
      ].freeze

      def self.options_for_select = PROVIDERS
      def self.codes = PROVIDERS.pluck(1)
      def self.names = PROVIDERS.pluck(0)
    end
  end
end
