# frozen_string_literal: true

module Renalware::Problems
  describe Comorbidities::Form do
    let(:user) { create(:user) }
    let(:patient) { create(:patient, by: user) }

    def build_params(description_id:, recognised:, recognised_at:, id: nil)
      ActiveSupport::HashWithIndifferentAccess.new(
        "comorbidities_attributes" => {
          "0" => {
            "description_id" => description_id,
            "recognised" => recognised,
            "recognised_at" => recognised_at,
            "id" => id
          }
        }
      )
    end

    describe "#comorbidities" do
      it "returns an array of possible comorbs, one for each description in the database, " \
         "using either the stored record if found or a new one if none exists" do
        # Create 2 descriptions
        # Create an existing comorb for desc1
        desc2 = create(:comorbidity_description, name: "Bb", position: 2)
        desc1 = create(:comorbidity_description, name: "Aa", position: 1)

        comorb1 = patient.comorbidities.create!(
          description: desc1,
          by: user,
          recognised: "yes",
          recognised_at: "2010-01-01"
        )

        form = described_class.new(patient: patient, by: user)

        expect(form.comorbidities.map(&:id)).to eq([comorb1.id, nil])
        expect(form.comorbidities.map(&:description_id)).to eq([desc1.id, desc2.id])
      end
    end

    describe "#save" do
      context "when given params containing an array comorbidities object" do
        it "ignores exsting comorbidities that are unchanged" do
          desc = create(:comorbidity_description)

          comorb1 = patient.comorbidities.create!(
            description: desc,
            by: user,
            recognised: "yes",
            recognised_at: "10-Jun-2021"
          )

          params = build_params(
            description_id: desc.id,
            recognised: "yes",
            recognised_at: "10-Jun-2021",
            id: comorb1.id
          )

          patient.comorbidities.reload # otherwise updated_at changes not reflected

          form = described_class.new(patient: patient, by: user, params: params)

          expect {
            form.save
          }.not_to change(comorb1, :updated_at)

          expect(comorb1.reload).to have_attributes(
            description_id: desc.id,
            recognised: "yes",
            recognised_at: Date.parse("10-Jun-2021")
          )
        end

        it "updates exsting comorbidities if they have changed" do
          desc = create(:comorbidity_description)

          comorb1 = patient.comorbidities.create!(
            description: desc,
            by: user,
            recognised: :yes,
            recognised_at: "10-Jun-2021"
          )

          params = build_params(
            description_id: desc.id,
            recognised: "no", # changed
            recognised_at: "11-Jun-2021", # changed
            id: comorb1.id
          )

          patient.comorbidities.reload # otherwise updated_at changes not reflected

          form = described_class.new(patient: patient, by: user, params: params)

          form.save

          expect(comorb1.reload).to have_attributes(
            description_id: desc.id,
            recognised: "no",
            recognised_at: Date.parse("11-Jun-2021")
          )
        end

        it "destroys exsting comorbidities that have changed to 'Unknown' with no date set" do
          desc = create(:comorbidity_description)

          comorb1 = patient.comorbidities.create!(
            description: desc,
            by: user,
            recognised: "yes",
            recognised_at: "10-Jun-2021"
          )

          params = build_params(
            description_id: desc.id,
            recognised: "unknown", # changed
            recognised_at: "", # changed to blank
            id: comorb1.id
          )

          form = described_class.new(patient: patient, by: user, params: params)
          form.save

          expect(patient.comorbidities.reload).to eq([])
        end

        it "does not save new comorbidities that are Unknown with no date as there are no point" \
           "saving records that do not say anything" do
          desc = create(:comorbidity_description)

          params = build_params(
            description_id: desc.id,
            recognised: "unknown", # default value
            recognised_at: "",
            id: "" # never saved
          )

          form = described_class.new(patient: patient, by: user, params: params)
          form.save

          expect(patient.comorbidities.reload).to eq([])
        end
      end
    end
  end
end
