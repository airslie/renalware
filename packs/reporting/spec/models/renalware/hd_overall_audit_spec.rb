# rubocop:disable RSpec/ExampleLength
module Renalware
  # HD Overall Audit is currently a materialized view
  describe "HD Overall Audit" do # rubocop:disable RSpec/DescribeClass
    include PatientsSpecHelper

    let(:user) { create(:user) }
    let(:view_name) { "reporting_hd_overall_audit" }
    let(:unit1) { create(:hospital_unit, name: "Unit1") }
    let(:unit2) { create(:hospital_unit, name: "Unit2") }
    let(:fistula_access_type) { create(:access_type, name: "a fistula access_type") }
    let(:graft_access_type) { create(:access_type, name: "a Graft access_type") }
    let(:other_access_type) { create(:access_type, name: "other access type") }

    def patient_with_access(access_type)
      create(:hd_patient).tap do |patient|
        create(
          :access_profile,
          patient: Accesses.cast_patient(patient),
          type_id: access_type.id,
          by: user
        )
      end
    end

    def parse_view_output
      Scenic.database.refresh_materialized_view(view_name)
      json = Reporting::FetchAuditJson.call(view_name)
      JSON.parse(json)["data"]&.map(&:symbolize_keys)
    end

    describe "json from hd_overall_audit materialized view" do
      describe ":data" do
        subject(:data) { parse_view_output }

        context "when there are no rows" do
          it { is_expected.to be_nil }
        end

        describe "#patient_count" do
          subject { parse_view_output.first[:patient_count] }

          before { create_list(:hd_patient_statistics, 2) }

          it { is_expected.to eq(2) }
        end

        context "when Jan and Feb 2018 data w 6 patients" do
          before do
            create_list(
              :hd_patient_statistics, 2,
              month: 1,
              year: 2018,
              hospital_unit: unit1
            )
            create_list(
              :hd_patient_statistics, 2,
              month: 2,
              year: 2018,
              hospital_unit: unit1
            )
            create_list(
              :hd_patient_statistics, 2,
              month: 1,
              year: 2018,
              hospital_unit: unit2
            )
          end

          it do
            expect(data).to eq(
              [
                {
                  name: "Unit1",
                  year: 2018,
                  month: 1,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0.0,
                  pct_missed_sessions_gt_10_pct: 0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: 0.0
                },
                {
                  name: "Unit1",
                  year: 2018,
                  month: 2,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0.0,
                  pct_missed_sessions_gt_10_pct: 0.0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: 0
                },
                {
                  name: "Unit2",
                  year: 2018,
                  month: 1,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0,
                  pct_missed_sessions_gt_10_pct: 0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: 0
                }
              ]
            )
          end
        end

        describe "percentage_access_fistula_or_graft" do
          subject {
            parse_view_output.first[:percentage_access_fistula_or_graft]
          }

          context "when two thirds of patients have fistula or graft access type" do
            before do
              create(
                :hd_patient_statistics,
                patient: patient_with_access(graft_access_type),
                month: 1,
                year: 2018,
                hospital_unit: unit1
              )
              create(
                :hd_patient_statistics,
                patient: patient_with_access(fistula_access_type),
                month: 1,
                year: 2018,
                hospital_unit: unit1
              )
              create(
                :hd_patient_statistics,
                patient: patient_with_access(other_access_type),
                month: 1,
                year: 2018,
                hospital_unit: unit1
              )
            end

            it { is_expected.to eq(66.67) }
          end

          context "when no patients have fistula or graft access type" do
            before do
              create(
                :hd_patient_statistics,
                patient: patient_with_access(other_access_type),
                month: 1,
                year: 2018,
                hospital_unit: unit1
              )
            end

            it { is_expected.to eq(0) }
          end

          context "when all patients have fistula or graft access type" do
            before do
              create(
                :hd_patient_statistics,
                patient: patient_with_access(fistula_access_type),
                month: 1,
                year: 2018,
                hospital_unit: unit1
              )
            end

            it { is_expected.to eq(100) }
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
