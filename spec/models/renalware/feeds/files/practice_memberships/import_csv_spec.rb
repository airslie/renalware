# frozen_string_literal: true

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        describe ImportCSV do
          let(:uk) { create(:united_kingdom) }

          def with_tmpfile(content)
            tmpfile = Tempfile.new("test_csv", Rails.root.join("tmp"))
            tmpfile.write(content)
            tmpfile.rewind
            ::File.chmod(0604, tmpfile)
            yield Pathname(tmpfile)
          ensure
            tmpfile.close
            tmpfile.unlink
          end

          context "when there are new memberships" do
            it "imports the GP memberships" do
              create(:practice, code: "PRAC_1")
              create(:practice, code: "PRAC_2")
              gp1 = create(:primary_care_physician, code: "GP111111")
              gp2 = create(:primary_care_physician, code: "GP222222")

              csv_content = <<~CSV
                "GP111111","PRAC_1","P","19740401","19910401","0"
                "GP222222","PRAC_2","P","19940401","","0"
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect {
                  described_class.new(tmpfile).call
                }
                  .to change(Patients::PracticeMembership, :count).by(2)
              end

              expect(gp1.reload.practice_memberships.first).to have_attributes(
                joined_on: Date.parse("1974-04-01"),
                left_on: Date.parse("1991-04-01"),
                active: false
              )

              expect(gp2.reload.practice_memberships.first).to have_attributes(
                joined_on: Date.parse("1994-04-01"),
                left_on: nil,
                active: true
              )
            end
          end

          context "when a gp is no longer in a practice" do
            it "they are soft deleted" do
              practice = create(:practice, code: "PRAC1")
              gp1 = create(:primary_care_physician, code: "GP1")
              gp2 = create(:primary_care_physician, code: "GP2")

              membership1 = create(
                :practice_membership,
                practice: practice,
                primary_care_physician: gp1
              )

              membership2 = create(
                :practice_membership,
                practice: practice,
                primary_care_physician: gp2
              )

              # Because GP2 is omitted from the CSV they should be marked as deleted
              csv_content = <<~CSV
                "GP1","PRAC1","P","19740401","19910401","0"
              CSV

              with_tmpfile(csv_content) do |tmpfile|
                expect {
                  described_class.new(tmpfile).call
                }
                  .to change(Patients::PracticeMembership, :count).by(-1)
                  .and change(Patients::PracticeMembership.deleted, :count).by(1)
              end

              expect(membership1.reload).not_to be_deleted
              expect(membership2.reload).to be_deleted
            end
          end
        end
      end
    end
  end
end
