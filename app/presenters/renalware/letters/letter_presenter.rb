require "collection_presenter"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      ADHOC_PRINTING_CSS = <<-STYLE.freeze
        <style>
          .footer .ccs h3 { margin-bottom: 4rem !important; }
          .footer .ccs .address { margin-bottom: 6rem !important; }
        </style>
      STYLE

      def type              = letter_event.to_link.call(patient)
      def patient           = @patient ||= PatientPresenter.new(super)
      def event_description = letter_event.description

      def simple_event_description
        clinic = letter_event.clinic
        return if clinic.blank?

        "Clinic: #{clinic.description} on #{::I18n.l(letter_event.date.to_date, format: :long)}"
      end

      def main_recipient
        @main_recipient ||= recipient_presenter_class.new(super)
      end

      def cc_recipients
        @cc_recipients ||= present_cc_recipients(build_cc_recipients)
      end

      # Unused can be removed
      # def cc_recipients_for_envelope_stuffing
      #   @cc_recipients_for_envelope_stuffing ||= begin
      #     recipients = build_cc_recipients
      #     present_cc_recipients(recipients)
      #   end
      # end

      # Unused, can be removed
      # def electronic_cc_receipts
      #   @electronic_cc_receipts ||=
      #     CollectionPresenter.new(super, Letters::ElectronicReceiptPresenter)
      # end

      def description = "(#{letterhead.site_code}) #{super}"
      def view_label = "Preview"
      def sections = SectionManager.new(__getobj__).sections

      def to_html(adhoc_printing: false)
        html = content
        html << ADHOC_PRINTING_CSS.html_safe if adhoc_printing
        html
      end

      def pdf_content
        archive&.pdf_content || RendererFactory.renderer_for(self, :pdf).call
      end

      def content
        if archived?
          archive.content
        else
          @content ||= Rendering::HtmlRenderer.new(self).call
        end
      end

      def hospital_unit_code = letterhead.site_code

      def hospital_unit_renal_registry_code
        ::Renalware::Hospitals::Unit.find_by(unit_code: hospital_unit_code)&.renal_registry_code
      end

      def title = pdf_stateless_filename

      def pdf_filename
        build_filename_from(
          [
            patient.family_name,
            patient.local_patient_id,
            id,
            state
          ]
        )
      end

      def pdf_stateless_filename
        build_filename_from(
          [
            patient.family_name,
            patient.local_patient_id,
            id
          ]
        )
      end

      def state_description
        ::I18n.t(state.to_sym, scope: "enums.letter.state")
      end

      def typist = created_by

      def patient_summary_string
        <<-PAT.squish
          #{patient.title.presence || patient.sex.salutation} #{patient.full_name}
          (#{patient.sex.code} DOB: #{::I18n.l(patient.born_on)}
          #{patient.hospital_identifiers} NHS No: #{patient.nhs_number})
        PAT
      end

      private

      def build_filename_from(arr)
        Array(arr).join("-").upcase.concat(".pdf")
      end

      # Include the counterpart cc recipients (i.e. patient and/or primary care physician)
      # Because of ApproveLetter#add_missing_counterpart_cc_recipients we need to only
      # bring in determine_counterpart_ccs if the letter is not yet approved
      def build_cc_recipients
        # Get CCs order by person_role: :desc so that gp floats above contacts
        persisted_ccs = __getobj__.cc_recipients.order(person_role: :desc)
        # There is an issue here - if we are archiving the letter then at the point the
        # archive html content is generated, the letter is signed but not yet approved.
        # We need to change this so it is approved before this point. For now
        # check if the letter is signed? which will indicate we are in the process of
        # archiving - in which case we have already generated the complete list of
        # letter_recipients so we don't need to use #determine_counterpart_ccs to derive
        # missing ones.
        if draft? || (pending_review? && !signed?)
          determine_counterpart_ccs + persisted_ccs
        else
          persisted_ccs
        end
      end

      def present_cc_recipients(recipients)
        ::CollectionPresenter.new(recipients, recipient_presenter_class)
      end

      def recipient_presenter_class = RecipientPresenter

      # @section sub-classes

      class Draft < LetterPresenter
        private

        def recipient_presenter_class
          RecipientPresenter::WithCurrentAddress
        end
      end

      class PendingReview < LetterPresenter
        private

        def recipient_presenter_class
          RecipientPresenter::WithCurrentAddress
        end
      end

      class Approved < LetterPresenter
        def view_label = "View"
      end

      class Completed < LetterPresenter
        def view_label = "View"
      end
    end
  end
end
