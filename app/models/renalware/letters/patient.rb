module Renalware
  module Letters
    class Patient < Renalware::Patient
      has_many :letters, dependent: :restrict_with_exception
      has_many :contacts, dependent: :restrict_with_exception
      belongs_to :primary_care_physician, class_name: "Renalware::Letters::PrimaryCarePhysician"

      def cc_on_letter?(letter)
        return false unless letter.subject?(self)
        return false unless cc_on_all_letters?

        !letter.main_recipient.patient?
      end

      def assign_contact(params)
        contacts.build(params)
      end

      def has_available_contact?(person)
        contacts.map(&:person).include?(person)
      end

      def has_default_cc?(person)
        contacts.default_ccs.map(&:person).include?(person)
      end

      def with_contact_for(person)
        contact = contacts.detect { |c| c.person == person }
        yield(contact)
      end
    end
  end
end
