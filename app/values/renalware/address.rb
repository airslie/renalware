module Renalware
  class Address < ApplicationRecord
    belongs_to :country, class_name: "System::Country", optional: true
    validates :email, email: true, allow_blank: true
    delegate :uk?, to: :country, allow_nil: true

    belongs_to :addressable, polymorphic: true
    before_validation :upcase_postcode

    # Set to true to avoid address validation - useful when archiving a letter with a migrated
    # address that might not have a postcode for instance
    attr_accessor :skip_validation

    validates_with AddressValidator, unless: :skip_validation

    def self.reject_if_blank
      lambda { |attrs|
        %w(name organisation_name street_1 street_2 street_3 town county postcode)
          .all? { |a| attrs[a].blank? }
      }
    end

    def copy_from(source)
      return self if source.blank?

      self.name = source.name
      self.organisation_name = source.organisation_name
      self.street_1 = source.street_1
      self.street_2 = source.street_2
      self.street_3 = source.street_3
      self.town = source.town
      self.county = source.county
      self.postcode = source.postcode
      self.country = source.country
      self
    end

    def to_s(format = nil)
      parts = [name, organisation_name, street_1, street_2, street_3, town, county]
      parts += [postcode, country] unless format == :without_postcode
      parts.compact_blank.join(", ")
    end

    def street
      [street_1, street_2, street_3].compact_blank.join(", ")
    end

    # Used eg in prawn pdf rendering
    def to_a
      [
        name,
        organisation_name,
        street_1,
        street_2,
        street_3,
        town,
        county,
        postcode,
        country
      ].compact_blank
    end

    private

    def upcase_postcode
      return if postcode.blank?

      self.postcode = postcode.upcase
    end
  end
end
