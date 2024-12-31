module Renalware::Pathology
  describe Sender do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:sending_facility)
      is_expected.to have_db_index(%i(sending_facility sending_application))
    end

    describe "#resolve!" do
      context "when the sender does not exist" do
        it "creates it using the facilty name and * for the application" do
          sender = nil

          expect {
            sender = described_class.resolve!(
              sending_facility: "Fac1",
              sending_application: "App1"
            )
          }.to change(described_class, :count).by(1)

          expect(sender).to have_attributes(
            sending_facility: "Fac1",
            sending_application: "*"
          )
        end
      end

      context "when the sender exist with a facilty and * application" do
        it "returns the row with '*' application" do
          original = described_class.create!(
            sending_facility: "Fac1",
            sending_application: "*"
          )
          found = nil
          expect {
            found = described_class.resolve!(
              sending_facility: "Fac1",
              sending_application: "App1"
            )
          }.not_to change(described_class, :count)

          expect(found).to eq(original)
        end
      end

      context "when the sender exist with a facilty and custom application" do
        it "returns the more specific row having the custom application" do
          described_class.create!(
            sending_facility: "Fac1",
            sending_application: "*"
          )
          original = described_class.create!(
            sending_facility: "Fac1",
            sending_application: "MyApp"
          )
          found = nil
          expect {
            found = described_class.resolve!(
              sending_facility: "Fac1",
              sending_application: "MyApp"
            )
          }.not_to change(described_class, :count)

          expect(found).to eq(original)
        end

        it "can match using a regex as the sending_facility" do
          sender1 = described_class.create!(
            sending_facility: "(Fac1|Fac2|other)",
            sending_application: "*"
          )
          described_class.create!(
            sending_facility: "Fac3",
            sending_application: "*"
          )

          sender = described_class.resolve!(
            sending_facility: "Fac2",
            sending_application: "MyApp"
          )

          expect(sender).to eq(sender1)
        end
      end
    end
  end
end
