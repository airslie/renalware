require_dependency "renalware/letters"

# A method object initialized with an instance of Letter reponsible
# for determining the "counterpart CC's". A counterpart CC can be a patient,
# primary care physician or both.
#
module Renalware
  module Letters
    class DetermineCounterpartCCs < SimpleDelegator
      def call
        counterpart_css = []
        counterpart_css << build_recipient("patient") if patient.cc_on_letter?(self)
        counterpart_css << build_recipient("primary_care_physician") if patient.primary_care_physician.cc_on_letter?(self)
        counterpart_css
      end

      private

      def build_recipient(person_role)
        Recipient.new(person_role: person_role, letter: __getobj__)
      end
    end
  end
end
