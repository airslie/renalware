describe "Patient's Protocol PDF" do
  include PathologySpecHelper
  let(:password) { "(&*G986111" }
  let(:user) { create(:user, password: password) }
  let(:patient) do
    create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345", by: user)
  end

  def create_recent_pathology_code_group
    descriptions = create_descriptions(%w(HGB PLT CRP))
    group = create(:pathology_code_group, :hd_session_form_recent, by: user)
    descriptions.each do |desc|
      create(
        :pathology_code_group_membership,
        code_group: group,
        observation_description: desc,
        by: user
      )
    end
  end

  describe "GET show" do
    it "responds with an inlined PDF by default" do
      get patient_hd_protocol_path(patient_id: patient)

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      expect(response["Content-Disposition"]).to include("inline")
      filename = "RABBIT-KCH12345-PROTOCOL.pdf"
      expect(response["Content-Disposition"]).to include(filename)
    end

    describe "Recent pathology" do
      it "displays latest HGB PLT CRP values" do
        create_recent_pathology_code_group
        # Pass debug=1 so we get back html rather than pdf (see pdf options in protocols controller)
        get patient_hd_protocol_path(patient_id: patient, debug: 1)

        expect(response).to be_successful
        expect(response.body).to include("HGB")
        expect(response.body).to include("PLT")
        expect(response.body).to include("CRP")

        # TODO: To test the actual values we would need to parse the template.
        # We could make this test a type: :system
      end
    end

    describe "Virology" do
      context "when the patient has no HIV, HepB or HepC" do
        it "displays blank Virology info" do
          # Pass debug=1 in order to render html not pdf
          get patient_hd_protocol_path(patient_id: patient, disposition: :attachment, debug: 1)

          expect(response).to be_successful
          expect(response.body).to include("HIV")
          expect(response.body).to include("Hepatitis B")
          expect(response.body).to include("Hepatitis C")
        end
      end

      context "when the patient is HIV+" do
        before do
          virology_patient = Renalware::Virology.cast_patient(patient)
          profile = virology_patient.profile || virology_patient.build_profile
          profile.document.hiv.status = :yes
          profile.document.hiv.confirmed_on_year = 2001
          profile.save!
        end

        it "displays just the HIV result" do
          get patient_hd_dashboard_path(patient)

          expect(response).to be_successful
          expect(response.body).to include("HIV")
          expect(response.body).to include("Yes (2001")
          expect(response.body).not_to include("Hepatitis B")
          expect(response.body).not_to include("Hepatitis C")
        end
      end
    end

    context "when the patient has prescriptions" do
      it "displays only 'give on hd' prescription" do
        drug1 = create(:drug, name: "Drug1")
        drug2 = create(:drug, name: "Drug2")
        create(:prescription, drug: drug1, administer_on_hd: true, patient: patient)
        create(:prescription, drug: drug2, administer_on_hd: false, patient: patient)

        get patient_hd_protocol_path(patient_id: patient, disposition: :attachment, debug: 1)

        expect(response).to be_successful
        expect(response.body).to include("Drug1")
        expect(response.body).not_to include("Drug2")
      end

      it "displays the 'last given' date for a drug, if present" do
        given_prescription = create(
          :prescription,
          administer_on_hd: true,
          patient: patient
        )
        create(
          :hd_prescription_administration,
          prescription: given_prescription,
          recorded_on: "2020-02-20",
          patient_id: patient.id,
          administered_by_password: password,
          administered_by: user,
          skip_witness_validation: true
        )
        create(
          :hd_prescription_administration,
          prescription: given_prescription,
          recorded_on: "2020-02-19",
          patient_id: patient.id,
          administered_by_password: password,
          administered_by: user,
          skip_witness_validation: true
        )

        get patient_hd_protocol_path(patient_id: patient, disposition: :attachment, debug: 1)

        expect(response).to be_successful
        expect(response.body).to include(given_prescription.drug_name)
        expect(response.body).to include("20-Feb-2020")
      end
    end
  end
end
