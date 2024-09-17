# frozen_string_literal: true

# rubocop:disable Layout/LineLength

module Renalware
  module Feeds
    module Files
      module PrimaryCarePhysicians
        describe ImportCSV do
          let(:uk) { build_stubbed(:united_kingdom) }

          def with_tmpfile(content)
            tmpfile = Tempfile.new("test_csv")
            tmpfile.write(content)
            tmpfile.rewind
            ::File.chmod(0604, tmpfile)
            yield Pathname(tmpfile)
          ensure
            tmpfile.close
            tmpfile.unlink
          end

          it "imports the GP correctly creating one active and inactive GP" do
            # Note JONES AA is active so deleted_at will be nil
            # SMITH BB is inactive so deleted_at will be set
            # code,name,f3,f4,street_1,street_2,street_3,town,county,postcode,f11,f12,status,f14,f15,f16,f17,telephone,f19,f20,f21,amended_record_indicator,f23,f24,f25,f26,f27
            csv_content = <<~CSV
              "G0102005","JONES AA","Y11","QAL","FIRCROFT, LONDON ROAD","ENGLEFIELD GREEN","EGHAM","SURREY","","TW20 0BS","19740401","","A","P","H81600","19740401","19910401","01232 232323","","","","0","","","","",""
              "G0102926","SMITH BB","Y55","Q79","LENSFIELD MEDICAL PRAC.","48 LENSFIELD ROAD","CAMBRIDGE","","","CB2 1EH","19740401","","C","O","D81001","19740401","19911231","01223 651011","","","","0","","06H","","",""
            CSV

            with_tmpfile(csv_content) do |tmpfile|
              expect {
                described_class.new(tmpfile).call
              }
                .to change(Patients::PrimaryCarePhysician, :count).by(1)
                .and change(Patients::PrimaryCarePhysician.deleted, :count).by(1)
            end

            gp = Patients::PrimaryCarePhysician.first
            expect(gp.code).to eq("G0102005")
            expect(gp.name).to eq("JONES AA")
            expect(gp.telephone).to eq("01232 232323")
          end

          context "when a GP was previously active but becomes inactive" do
            it "soft deletes it" do
              previously_active_gp = create(
                :primary_care_physician,
                code: "G0102926",
                name: "SMITH BB",
                telephone: "01223 651011"
              )
              # code,name,f3,f4,street_1,street_2,street_3,town,county,postcode,f11,f12,status,f14,f15,f16,f17,telephone,f19,f20,f21,amended_record_indicator,f23,f24,f25,f26,f27
              csv_content = <<~CSV
                "G0102926","SMITH BB","Y55","Q79","LENSFIELD MEDICAL PRAC.","48 LENSFIELD ROAD","CAMBRIDGE","","","CB2 1EH","19740401","","C","O","D81001","19740401","19911231","01223 651011","","","","0","","06H","","",""
              CSV
              with_tmpfile(csv_content) do |tmpfile|
                expect {
                  described_class.new(tmpfile).call
                }
                  .to change(Patients::PrimaryCarePhysician, :count).by(-1)
                  .and change(Patients::PrimaryCarePhysician.deleted, :count).by(1)
              end

              expect(previously_active_gp.reload.deleted_at).to be_present
            end
          end

          context "when a GP was previously inactive but becomes active" do
            it "removes the soft delete" do
              previously_inactive_gp = create(
                :primary_care_physician,
                code: "G0102005",
                name: "JONES AA",
                deleted_at: 1.year.ago
              )

              # code,name,f3,f4,street_1,street_2,street_3,town,county,postcode,f11,f12,status,f14,f15,f16,f17,telephone,f19,f20,f21,amended_record_indicator,f23,f24,f25,f26,f27
              csv_content = <<~CSV
                "G0102005","JONES AA","Y11","QAL","FIRCROFT, LONDON ROAD","ENGLEFIELD GREEN","EGHAM","SURREY","","TW20 0BS","19740401","","A","P","H81600","19740401","19910401","01232 232323","","","","0","","","","",""
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect {
                  described_class.new(tmpfile).call
                }
                  .to change(Patients::PrimaryCarePhysician, :count).by(1)
                  .and change(Patients::PrimaryCarePhysician.deleted, :count).by(-1)
              end

              expect(previously_inactive_gp.reload.deleted_at).to be_nil
            end
          end

          # rubocop:disable RSpec/ChangeByZero
          context "when GP exists but their properties have changed" do
            it "updates appropriate properties" do
              gp = create(
                :primary_care_physician,
                code: "G1111111",
                name: "MILNE AA",
                telephone: "0111 0000000"
              )

              # code,name,f3,f4,street_1,street_2,street_3,town,county,postcode,f11,f12,status,f14,f15,f16,f17,telephone,f19,f20,f21,amended_record_indicator,f23,f24,f25,f26,f27
              # Name may have changed due to marriage
              # Telephone could change
              csv_content = <<~CSV
                "G1111111","MILNE AA","Y11","QAL","XYZ, LONDON ROAD","ENGLEFIELD GREEN","EGHAM","SURREY","","TW01 1BS","19730401","","A","P","H81600","19740401","19910401","01232 232323","","","","0","","","","",""
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect {
                  described_class.new(tmpfile).call
                }
                  .to change(Patients::PrimaryCarePhysician, :count).by(0)
                  .and change(Patients::PrimaryCarePhysician.deleted, :count).by(0)
              end

              gp.reload
              expect(gp.code).to eq("G1111111")
              expect(gp.name).to eq("MILNE AA")
              expect(gp.telephone).to eq("01232 232323") # changed
              expect(gp.address.to_s).to eq(
                "XYZ, LONDON ROAD, ENGLEFIELD GREEN, EGHAM, SURREY, TW01 1BS"
              )
            end
          end
          # rubocop:enable RSpec/ChangeByZero
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
