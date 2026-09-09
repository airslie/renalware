require "csv"

module Renalware
  module Patients
    module ODS
      module DSE
        describe Synchroniser do
          let(:reports) do
            described_class::REPORTS.transform_values { |options| options.merge(minimum_rows: 1) }
          end

          def csv_row(size, attributes)
            row = Array.new(size, "")
            attributes.each { |index, value| row[index] = value }
            CSV.generate_line(row)
          end

          def downloader_for(contents)
            instance_double(Downloader).tap do |downloader|
              allow(downloader).to receive(:call) do |report_name|
                Tempfile.new([report_name, ".csv"]).tap do |file|
                  file.write(contents.fetch(report_name))
                  file.flush
                  file.rewind
                end
              end
            end
          end

          def report_contents
            {
              "epraccur" => practice_report,
              "egpcur" => gp_report,
              "epracmem" => membership_report
            }
          end

          def practice_report
            csv_row(
              27,
              0 => "A81001",
              1 => "NEW PRACTICE NAME",
              4 => "NEW STREET",
              7 => "NEW TOWN",
              9 => "AA1 1AA",
              12 => "ACTIVE",
              17 => "01234567890"
            )
          end

          def gp_report
            [
              csv_row(27, 0 => "G0102926", 1 => "NEW GP NAME", 12 => "ACTIVE", 17 => "111"),
              csv_row(27, 0 => "G0105912", 1 => "RETURNED GP", 12 => "ACTIVE", 17 => "222"),
              csv_row(27, 0 => "G0107000", 1 => "RETIRED GP", 12 => "RETIRED", 17 => "333")
            ].join
          end

          def membership_report
            [
              current_membership,
              historic_membership,
              csv_row(6, 0 => "G0105912", 1 => "A81001", 2 => "P", 3 => "20250102", 5 => "1")
            ].join
          end

          def current_membership
            csv_row(
              6,
              0 => "G0102926",
              1 => "A81001",
              2 => "P",
              3 => "20200101",
              4 => "20250101",
              5 => "1"
            )
          end

          def historic_membership
            csv_row(
              6,
              0 => "G0102926",
              1 => "A81001",
              2 => "P",
              3 => "20100101",
              4 => "20110101",
              5 => "1"
            )
          end

          it "atomically reconciles practices, GPs and memberships while preserving defaults" do # rubocop:disable RSpec/ExampleLength
            create(:united_kingdom)
            practice = create(:practice, code: "A81001", name: "OLD PRACTICE NAME", active: false)
            gp = create(
              :primary_care_physician,
              code: "G0102926",
              name: "OLD GP NAME",
              telephone: "111"
            )
            returned_gp = create(:primary_care_physician, code: "G0105912", deleted_at: 1.year.ago)
            membership = create(:practice_membership, practice:, primary_care_physician: gp)
            returned_membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: returned_gp,
              deleted_at: 1.year.ago,
              ods_managed: true
            )
            stale_membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: create(:primary_care_physician, code: "G0108000"),
              ods_managed: true
            )
            default_membership = create(
              :practice_membership,
              practice:,
              primary_care_physician: PrimaryCarePhysician.generic,
              default_gp: true
            )

            described_class.new(
              downloader: downloader_for(report_contents),
              reports:
            ).call

            expect(practice.reload).to have_attributes(
              name: "NEW PRACTICE NAME",
              telephone: "01234567890",
              active: true,
              ods_managed: true
            )
            expect(practice.address.reload).to have_attributes(
              street_1: "NEW STREET",
              town: "NEW TOWN",
              postcode: "AA1 1AA"
            )
            expect(gp.reload).to have_attributes(name: "NEW GP NAME", ods_managed: true)
            expect(returned_gp.reload).not_to be_deleted
            expect(PrimaryCarePhysician.unscoped.find_by!(code: "G0107000")).to be_deleted
            expect(membership.reload).to have_attributes(
              joined_on: Date.new(2020, 1, 1),
              left_on: Date.new(2025, 1, 1),
              active: false,
              ods_managed: true
            )
            expect(returned_membership.reload).not_to be_deleted
            expect(stale_membership.reload).to be_deleted
            expect(default_membership.reload).not_to be_deleted
            expect(System::APILog.last.values).to include(
              "source_rows_practices=1",
              "source_rows_primary_care_physicians=3",
              "source_rows_practice_memberships=3"
            )
          end

          it "rolls back all imported changes in a dry run" do
            create(:united_kingdom)
            practice = create(:practice, code: "A81001", name: "OLD PRACTICE NAME")

            result = described_class.new(
              dry_run: true,
              downloader: downloader_for(report_contents),
              reports:
            ).call

            expect(practice.reload.name).to eq("OLD PRACTICE NAME")
            expect(
              PrimaryCarePhysician.where(code: %w(G0102926 G0105912 G0107000))
            ).to be_empty
            expect(result.dig(:after, :primary_care_physicians)).to eq(3)
          end

          it "rolls back earlier imports if a later importer fails" do
            create(:united_kingdom)
            practice = create(:practice, code: "A81001", name: "OLD PRACTICE NAME")
            failing_importer = Class.new do
              def initialize(*) = nil
              def call = raise("membership import failed")
            end
            failing_reports = reports.deep_dup
            failing_reports[:practice_memberships][:importer] = failing_importer

            expect {
              described_class.new(
                downloader: downloader_for(report_contents),
                reports: failing_reports
              ).call
            }.to raise_error("membership import failed")

            expect(practice.reload.name).to eq("OLD PRACTICE NAME")
            expect(PrimaryCarePhysician.unscoped.where(code: "G0102926")).to be_empty
          end

          it "rejects a report more than 15 percent smaller than the previous successful one" do
            create(
              :api_log,
              identifier: described_class::API_LOG_IDENTIFIER,
              values: ["source_rows_practices=100"]
            )
            contents = report_contents.merge("epraccur" => practice_report * 84)

            expect {
              described_class.new(
                downloader: downloader_for(contents),
                reports:
              ).call
            }.to raise_error(ValidationError, /only 84 rows; expected at least 85/)
          end
        end
      end
    end
  end
end
