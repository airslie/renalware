# TODO: list

# Anaemia Audit
# - Refactor helpers into an AuditHelper mixin as some duplication here with other audit tests.
# - Remove rubocop disable above
# - Rename bone audit describe block
# rubocop:disable RSpec/ExampleLength, RSpec/DescribeClass
module Renalware
  describe "Anaemia Audit" do
    include PatientsSpecHelper
    let(:uom) { create(:pathology_measurement_unit) }
    let(:user) { create(:user) }
    let(:audit_view_name) { "reporting_anaemia_audit" }
    let(:request_description) { create(:pathology_request_description, lab: lab) }
    let(:lab) { create(:pathology_lab) }

    def create_observation_description(code)
      create(:pathology_observation_description, code: code, measurement_unit: uom)
    end

    def create_observation(patient:, description:, result:)
      request = create(
        :pathology_observation_request,
        patient: patient,
        description: request_description
      )
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

    describe "json from reporting_aneamia_audit view" do
      describe ":data" do
        context "when there are no rows in the audit" do
          it "is nil" do
            json = Reporting::FetchAuditJson.call(audit_view_name)
            result = JSON.parse(json)
            expect(result["data"]).to be_nil
          end
        end

        context "when there are rows in the report" do
          it "is correctly generates json" do
            # We will just add path data to 2 HD patients in this example.
            # We just create a PD patient to test that PD patient_count is correct
            # in the view output.
            hd_patients = Array.new(4) { create_hd_patient }
            create_pd_patient

            # HGB
            hgb = create_observation_description("HGB")
            create_observation(patient: hd_patients[0], description: hgb, result: 9)
            create_observation(patient: hd_patients[1], description: hgb, result: 10)
            create_observation(patient: hd_patients[2], description: hgb, result: 11)
            create_observation(patient: hd_patients[3], description: hgb, result: 14)

            # FER
            fer = create_observation_description("FER")
            create_observation(patient: hd_patients[0], description: fer, result: 140)
            create_observation(patient: hd_patients[1], description: fer, result: 150)
            create_observation(patient: hd_patients[2], description: fer, result: 205)

            # hd_patients 1 and 2 have an EPO drug so no_on_epo should eq 2
            immunosuppressant_drug = create(:drug, :immunosuppressant)
            hd_patients[0, 2].each do |patient|
              create(:prescription, patient: patient, drug: immunosuppressant_drug)
            end

            # hd_patients 1 and 2 also have an a drug starting with Mircer
            mircera_injection = create(:drug, name: "Mircera Injection")
            hd_patients[0, 2].each do |patient|
              create(:prescription, patient: patient, drug: mircera_injection)
            end

            # hd_patient 3 has a drug starting with Neo
            neomycin = create(:drug, name: "Neomycin Elixir")
            create(:prescription, patient: hd_patients[2], drug: neomycin)

            # hd_patient 4 has a drug starting with Ara
            arachis_oil = create(:drug, name: "Arachis Oil")
            create(:prescription, patient: hd_patients[3], drug: arachis_oil)

            json = Reporting::FetchAuditJson.call(audit_view_name)
            result = JSON.parse(json).deep_symbolize_keys!

            expect(result[:data].sort_by { |a| a[:modality] }).to eq(
              [
                {
                  modality: "HD",
                  patient_count: 4,
                  avg_hgb: 11.0,            # avg_hgb (9 + 10 + 11 + 14) / 4 = 11
                  pct_hgb_gt_eq_10: 75.0,   # pct_hgb_gt_eq_10 = all bar 1 = 75%
                  pct_hgb_gt_eq_11: 50.0,   # pct_hgb_gt_eq_11 = 2 = 50%
                  pct_hgb_gt_eq_13: 25.0,   # pct_hgb_gt_eq_13 = 1 = 25%
                  avg_fer: 165.0,           # avg_fer = (140 + 150 + 205) / 3 = 165
                  pct_fer_gt_eq_150: 66.67, # pct_fer_gt_eq_150 = 2 of 3 = 66.66
                  count_epo: 2,
                  count_mircer: 2,
                  count_neo: 1,
                  count_ara: 1
                },
                {
                  modality: "PD",
                  patient_count: 1,
                  avg_hgb: nil,
                  pct_hgb_gt_eq_10: 0.0,
                  pct_hgb_gt_eq_11: 0.0,
                  pct_hgb_gt_eq_13: 0.0,
                  avg_fer: nil,
                  pct_fer_gt_eq_150: 0.0,
                  count_epo: 0,
                  count_mircer: 0,
                  count_neo: 0,
                  count_ara: 0
                }
              ]
            )
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/DescribeClass
