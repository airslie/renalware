module Renalware
  describe UKRDC::XmlRenderer do
    context "when data is valid" do
      it "returns the XML as string" do
        practice = build_stubbed(:practice, code: "A12345")
        gp = build_stubbed(:primary_care_physician, code: "G1111111")
        patient = build_stubbed(:patient,
                                practice: practice,
                                primary_care_physician: gp,
                                renal_registry_id: "123")
        patient_presenter = UKRDC::PatientPresenter.new(patient)
        renderer = described_class.new(
          schema: UKRDC::XsdSchema.new,
          locals: { patient: patient_presenter }
        )

        result = renderer.call

        expect(result).to be_success
        expect(result.xml).to be_present
        expect(result.xml).to be_a(String)
        expect(result.xml).to include("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
      end
    end

    context "when the XML does not pass UKRDC XSD validation" do
      it "raise an exception with the errors" do
        practice = build_stubbed(:practice, code: "invalid_practice_code")
        gp = build_stubbed(:primary_care_physician, code: "invalid_gp_code")
        patient = build_stubbed(:patient,
                                practice: practice,
                                primary_care_physician: gp,
                                renal_registry_id: "123")
        patient_presenter = UKRDC::PatientPresenter.new(patient)
        renderer = described_class.new(
          schema: UKRDC::XsdSchema.new,
          locals: { patient: patient_presenter }
        )

        # Should return a Failure object
        result = renderer.call

        expect(result).to be_failure
        expect(result).to be_a(Failure)
        expect(result.validation_errors).to be_a(Array)

        # There will be 3 errors about GPPracticeId
        # - too long
        # - not correct pattern eg not matching G[0-9]{7}
        expect(
          result.validation_errors.count { |x| x.message.include?("GPPracticeId") }
        ).to eq(2)

        # There will be 3 errors about GPId
        # - too long
        # - not correct pattern eg not matching G[0-9]{7}
        expect(
          result.validation_errors.count { |x| x.message.include?("GPId") }
        ).to eq(2)
      end
    end
  end
end
