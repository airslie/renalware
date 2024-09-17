# frozen_string_literal: true

module Renalware
  describe "Bone Audit" do
    include PatientsSpecHelper
    let(:uom) { create(:pathology_measurement_unit) }
    let(:user) { create(:user) }

    def create_observation_description(code)
      create(:pathology_observation_description, code: code, measurement_unit: uom)
    end

    def create_observation(patient:, description:, result:)
      request = create(:pathology_observation_request, patient: patient)
      create(
        :pathology_observation,
        request: request,
        description: description,
        result: result
      )
    end

    def create_hd_patient
      create(:pathology_patient, by: user).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:hd_modality_description),
                     by: user)
      end
    end

    def create_pd_patient
      create(:pathology_patient, by: user).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:pd_modality_description),
                     by: user)
      end
    end

    describe "json from reporting_bone_audit view" do
      describe ":data" do
        context "when are no rows" do
          it "is nil" do
            json = Reporting::FetchAuditJson.call("reporting_bone_audit")
            expect(JSON.parse(json)["data"]).to be_nil
          end
        end

        context "when there are rows in the view" do
          it "generates the correct json" do
            # We will just add path data to 2 HD patients in this example.
            # We just create a PD patient to test that PD patient_count is correct
            # in the view output.
            hd_patient1 = create_hd_patient
            hd_patient2 = create_hd_patient
            create_pd_patient

            # CCA
            cca = create_observation_description("CCA")
            create_observation(patient: hd_patient1, description: cca, result: 2.0)
            create_observation(patient: hd_patient2, description: cca, result: 2.3)

            # PTH
            pth = create_observation_description("PTHI")
            create_observation(patient: hd_patient1, description: pth, result: 300.1)
            create_observation(patient: hd_patient2, description: pth, result: 800.1)

            # PHOS
            phos = create_observation_description("PHOS")
            create_observation(patient: hd_patient1, description: phos, result: 2.0)
            create_observation(patient: hd_patient2, description: phos, result: 1.0)

            json = Reporting::FetchAuditJson.call("reporting_bone_audit")
            result = JSON.parse(json).deep_symbolize_keys!

            data = result[:data]
            pd = data.find { |x| x[:modality] == "PD" }
            hd = data.find { |x| x[:modality] == "HD" }

            expect(pd).to eq(
              modality: "PD",
              patient_count: 1,
              avg_cca: nil,
              pct_cca_2_1_to_2_4: 0.0,
              pct_pth_gt_300: 0.0,
              pct_pth_gt_800_pct: 0.0,
              avg_phos: nil,
              max_phos: nil,
              pct_phos_lt_1_8: 0.0
            )
            expect(hd).to eq(
              modality: "HD",
              patient_count: 2,
              avg_cca: 2.15,
              pct_cca_2_1_to_2_4: 50.0,
              pct_pth_gt_300: 100.0,
              pct_pth_gt_800_pct: 50.0,
              avg_phos: 1.5,
              max_phos: 2.0,
              pct_phos_lt_1_8: 50.0 # pct_phos_lt_1_8 = 50%
            )
          end
        end
      end
    end
  end
end
