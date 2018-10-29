# frozen_string_literal: true

require_dependency "renalware/letters"
require "collection_presenter"

# rubocop:disable Metrics/ClassLength
module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      ADHOC_PRINTING_CSS = <<-STYLE
        <style>
          .footer .ccs h3 { margin-bottom: 4rem !important; }
          .footer .ccs .address { margin-bottom: 6rem !important; }
        </style>
      STYLE

      def type
        letter_event.to_link.call(patient)
      end

      def patient
        @patient ||= PatientPresenter.new(super)
      end

      def event_description
        letter_event.description
      end

      def main_recipient
        @main_recipient ||= recipient_presenter_class.new(super)
      end

      def cc_recipients
        @cc_recipients ||= begin
          recipients = build_cc_recipients
          present_cc_recipients(recipients)
        end
      end

      def electronic_cc_receipts
        @electronic_cc_receipts ||=
          CollectionPresenter.new(super, Letters::ElectonicReceiptPresenter)
      end

      def description
        "(#{letterhead.site_code}) #{super}"
      end

      def view_label
        "Preview"
      end

      def parts
        filtered_part_classes = PartClassFilter.new(
          part_classes: letter_event.part_classes,
          include_pathology_in_letter_body: letterhead.include_pathology_in_letter_body?
        )
        filtered_part_classes.to_h.values.map do |part_class|
          part_class.new(patient, self, letter_event)
        end
      end

      def part_for(part_name)
        letter_event.part_classes[part_name].new(patient, self, letter_event)
      end

      # rubocop:disable Rails/OutputSafety
      def to_html(adhoc_printing: false)
        html = content
        html << ADHOC_PRINTING_CSS.html_safe if adhoc_printing
        html
      end
      # rubocop:enable Rails/OutputSafety

      def content
        if archived?
          archive.content
        else
          @content ||= HTMLRenderer.new.call(self)
        end
      end

      def hospital_unit_code
        letterhead.site_code
      end

      def title
        pdf_stateless_filename
      end

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

      def typist
        created_by
      end

      private

      def build_filename_from(arr)
        Array(arr).join("-").upcase.concat(".pdf")
      end

      # Include the counterpart cc recipients (i.e. patient and/or primary care physician)
      def build_cc_recipients
        determine_counterpart_ccs + __getobj__.cc_recipients
      end

      def present_cc_recipients(recipients)
        ::CollectionPresenter.new(recipients, recipient_presenter_class)
      end

      def recipient_presenter_class
        RecipientPresenter
      end

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
        def view_label
          "View"
        end
      end

      class Completed < LetterPresenter
        def view_label
          "View"
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
