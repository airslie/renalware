# A method object initialized with an instance of Letter responsible
# for determining the "counterpart CC's". A counterpart CC can be a patient,
# primary care physician or both.
#
module Renalware
  module Letters
    class DetermineCounterpartCCs < SimpleDelegator
      def call
        counterpart_css = []
        counterpart_css << build_recipient("patient", patient) if cc_patient?
        if cc_primary_care_physician?
          counterpart_css << build_recipient("primary_care_physician", primary_care_physician)
        end
        counterpart_css
      end

      private

      def cc_primary_care_physician?
        pcp = patient.primary_care_physician
        pcp&.cc_on_letter?(self)
      end

      def cc_patient?
        patient.cc_on_letter?(self)
      end

      def build_recipient(person_role, addressee)
        Recipient.new(
          person_role: person_role,
          role: :cc,
          addressee: addressee,
          letter: __getobj__
        )
      end
    end
  end
end
