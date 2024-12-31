module World
  module Letters::PrimaryCarePhysician
    module Domain
      # @section expectations
      #
      def expect_doctor_can_review_letter(patient:, doctor:)
        patient = Renalware::Letters.cast_patient(patient)
        letter = simple_letter_for(patient)
        result = patient.letters.reviewable.include?(letter)

        expect(result).to be_truthy
      end
    end

    module Web
      include Domain
    end
  end
end
