module Renalware
  module Letters
    class Recipient < ApplicationRecord
      extend Enumerize

      belongs_to :letter
      belongs_to :addressee, polymorphic: true
      has_one :address, as: :addressable # for archiving purposes

      enumerize :role, in: %i(main cc)
      enumerize :person_role, in: %i(patient primary_care_physician contact)

      accepts_nested_attributes_for :address,
                                    allow_destroy: true,
                                    reject_if: :patient_or_primary_care_physician?

      validates :addressee_id, presence: { if: :contact? }
      validate :person_role_present?

      # Return all recipients excluding
      # - any that have been emailed (ie emailed to practice)
      # - the GP if their copy has been successfully sent via eg MESH
      # TODO: Improve the mess here
      def self.printable_recipients_for(letter)
        recipients = [letter.main_recipient]
        recipients.concat(letter.cc_recipients)
        recipients.reject! { |recipient| recipient.emailed_at.present? }
        recipients.reject!(&:statement_to_indicate_letter_will_be_emailed)
        recipients.reject!(&:primary_care_physician?) if letter.gp_send_status.to_sym == :success
        CollectionPresenter.new(recipients, RecipientPresenter::WithCurrentAddress)
      end

      # Check we have a person_role. If we don't add an error to the parent letter if one is
      # present, otherwise add to our errors.
      def person_role_present?
        return if person_role.present?

        errs = letter&.errors || errors
        errs.add(:base, "Please select a main recipient")
      end

      delegate :primary_care_physician?, :patient?, :contact?, to: :person_role, allow_nil: true

      def to_s
        (address || current_address).to_s
      end

      # Archiving a letter means taking the current address for the recipient (they could be a
      # practice, patient, gp etc) and copying their address into a new Address row so it becomes
      # immutably recorded as a definitive statement of where the letter was sent.
      # Without this, if for example the patient's address subsequently changes, we would only be
      # able to resolve the new address for the patient, not the address used at the time the letter
      # was sent. We could also look at the archived letter content however to see what was
      # physically on the letter, but we can't do that in SQL.
      def archive!
        build_address if address.blank?

        address.copy_from(current_address)

        # Its possible a migrated address might not have a postcode. Don't let archiving fail
        # at this stage because of that as the user cannot be informed at this stage
        # so skip address validation.
        address.skip_validation = true

        address.save!
      end

      def current_address
        return address_for_patient if patient?
        return practice_address_for_patient if primary_care_physician?

        address_for_addressee_eg_contact
      end

      def for_contact?(contact)
        return false unless person_role.contact?

        addressee_id == contact.id
      end

      def statement_to_indicate_letter_will_be_emailed
        if primary_care_physician? && practice_email_address.present?
          "VIA EMAIL to #{practice_email_address}"
        end
      end

      private

      def address_for_patient
        letter.patient.current_address.tap do |address|
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            letter.patient.full_name
          )
        end
      end

      def practice_address_for_patient
        address = letter.patient&.practice&.address
        ensure_practice_name_is_present_in(address)

        if address.present? && letter.primary_care_physician.present?
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            letter.primary_care_physician.to_s
          )
        end
        address
      end

      # There may not be an organisation name eg "Mill House Clinic" on the address record
      # (in fact is unlikely) in which case copy it over from the practice so it will be displayed
      # under the GP's name on the letter.
      def ensure_practice_name_is_present_in(address)
        return if address.blank?

        address.organisation_name ||= letter.patient&.practice&.name
      end

      def address_for_addressee_eg_contact
        addressee.address.tap do |address|
          ensure_address_has_a_name_required_when_displaying_letters(
            address,
            addressee.respond_to?(:full_name) ? addressee.full_name : addressee.to_s
          )
        end
      end

      def patient_or_primary_care_physician?
        patient? || primary_care_physician?
      end

      def practice_email_address
        @practice_email_address ||= letter.patient&.practice&.email
      end

      # Make sure we have a 'name' set in the address record set as this is used in the letter
      # e.g. Roger Robbit <- address.name
      #      123 Toon Town
      #      ...
      # Note address.name is a redundant field not consistently populated in the app
      # and should be removed. However its consumed in a quite a few places building letters
      # and displaying the letter form, hence this hack.
      def ensure_address_has_a_name_required_when_displaying_letters(address, name)
        address.name = name if address.present? && address.name.blank?
      end
    end
  end
end
