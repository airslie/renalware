module Renalware
  module Personable
    extend ActiveSupport::Concern

    included do
      class_eval do
        validates :family_name, presence: true
        validates :given_name,
                  presence: {
                    unless: lambda {
                      defined?(skip_given_name_validation?) && skip_given_name_validation?
                    }
                  }
      end

      def full_name
        [given_name, family_name].compact.join(" ")
      end

      def to_s(format = :default)
        case format
        when :default
          [family_name, given_name].compact.join(", ")
        when :long
          "#{family_name}, #{given_name} (#{nhs_number})"
        end
      end

      def salutation
        parts = [Renalware.config.salutation_prefix]
        parts << (title.presence || given_name)
        parts << family_name
        parts.compact.join(" ")
      end
    end
  end
end
