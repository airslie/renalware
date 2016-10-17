require_dependency "renalware/letters"

# This class is responsible for transforming the attributes
# of a letter.  The resulting attributes can then
# be mass assigned to an ActiveRecord letter object.
module Renalware
  module Letters
    class LetterParamsProcessor
      def initialize(patient)
        @patient = patient
      end

      def call(params)
        params = process_main_recipient_attributes(params)
        process_cc_recipients_attributes(params)
      end

      private

      def process_main_recipient_attributes(params)
        return params unless params.has_key?(:main_recipient_attributes)

        params.merge(
          main_recipient_attributes: main_recipient_attributes(params)
        )
      end

      def process_cc_recipients_attributes(params)
        return params unless params.has_key?(:cc_recipients_attributes)

        params.merge(
          cc_recipients_attributes: cc_recipients_attributes(params)
        )
      end

      def main_recipient_attributes(params)
        recipient_attributes(params[:main_recipient_attributes])
      end

      def cc_recipients_attributes(params)
        params[:cc_recipients_attributes].map do |attributes|
          recipient_attributes(attributes)
        end
      end

      def recipient_attributes(params)
        RecipientParamsProcessor.new(@patient).call(params)
      end
    end
  end
end