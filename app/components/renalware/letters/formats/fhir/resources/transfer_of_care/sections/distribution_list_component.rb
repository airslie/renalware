module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class DistributionListComponent < SectionComponent
      delegate :primary_care_physician, :practice, to: :patient
      delegate :name, to: :primary_care_physician, prefix: true, allow_nil: true
      delegate :name, :address, to: :practice, prefix: true, allow_nil: true

      class SimpleRecipient
        include ActiveModel::Model
        include ActiveModel::Attributes
        attribute :name, :string
        attribute :role, :string
        attribute :organisation, :string
      end

      def presented_letter
        @presented_letter ||= Letters::LetterPresenter.new(letter)
      end

      def effective_recipient(recipient)
        recipient
      end

      def recipients
        [main_recipient] + electronic_cc_recipients + cc_recipients
      end

      def main_recipient
        if letter.main_recipient&.primary_care_physician?
          SimpleRecipient.new(
            name: primary_care_physician_name,
            role: "General Medical Practitioner",
            organisation: practice_name
          )
        elsif letter.main_recipient&.patient?
          SimpleRecipient.new(name: patient.full_name)
        else
          raise "Unrecgonised main_recipient type"
        end
      end

      def electronic_cc_recipients
        presented_letter.electronic_cc_recipients.map do |user|
          SimpleRecipient.new(
            name: user.signature || user.full_name,
            role: user.professional_position,
            organisation: user.hospital_centre&.name
          )
        end
      end

      def cc_recipients
        presented_letter.cc_recipients.map do |recipient|
          SimpleRecipient.new(
            name: recipient.to_s
          )
        end
      end
    end
  end
end
