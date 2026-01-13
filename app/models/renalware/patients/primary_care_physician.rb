module Renalware
  module Patients
    # Represents a Primary Care Physician (PCP). The PCP could either be:
    # - a UK-based General Practitioner (GP)
    # - a foreign PCP or other referring physician
    #
    class PrimaryCarePhysician < ApplicationRecord
      include ActiveModel::Validations

      # include Personable
      acts_as_paranoid

      has_one :address, as: :addressable
      has_many :patients, dependent: :restrict_with_exception
      has_many :practice_memberships, dependent: :restrict_with_exception
      has_many :practices, through: :practice_memberships

      accepts_nested_attributes_for :address, reject_if: Address.reject_if_blank

      validates_with PrimaryCarePhysicians::AddressValidator
      validates :code, uniqueness: true
      validates :practitioner_type, presence: true
      validates :name, presence: true
      alias_attribute :family_name, :name

      scope :ordered, -> { order(default_gp: :asc, name: :asc) }

      # Used when the patient has a practice but no gp assigned, and we need to
      # send them a letter. We add this generic GP to any practice that needs it in order to be
      # able to send a letter.
      def self.generic
        gp = find_or_initialize_by(name: "General Practitioner", code: "GENERIC")
        if gp.new_record?
          gp.practitioner_type = "GP"
          # Don't validate because PrimaryCarePhysicians::AddressValidator says at least one
          # practice must be present, at there none at this point.
          gp.save!(validate: false)
        end
        gp
      end

      def full_name     = :name
      def given_name    = ""
      def to_s          = [title, name].compact.join(" ")
      def title         = "Dr"
      def skip_given_name_validation? = true

      def salutation
        [
          Renalware.config.salutation_prefix,
          title,
          name
        ].compact.join(" ")
      end

      class PrimaryCarePhysicianAddressAccessError < StandardError; end

      def current_address
        raise PrimaryCarePhysicianAddressAccessError,
              "primary_care_physician#current_address should not be called: " \
              "we always use the patient.practice.address when contacting the GP. " \
              "In a sense the practice is more important that the GP, as the GP may have " \
              "moved on"
        # address || practice_address
      end

      def practice_address
        address = practices.first.try(:address)
        address.name = "#{title} #{name}".strip if address.present?
        address
      end
    end
  end
end
