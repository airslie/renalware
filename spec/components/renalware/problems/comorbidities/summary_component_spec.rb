# frozen_string_literal: true

describe Renalware::Problems::Comorbidities::SummaryComponent, type: :component do
  subject(:component) do
    described_class.new(
      patient: patient,
      current_user: user,
      at_date: at_date,
      display_blank: display_blank
    )
  end

  let(:user) { create(:user) }
  let(:patient) { create(:patient, by: user) }
  let(:at_date) { nil }
  let(:display_blank) { false }

  def create_comorbidity(name: "xx", pos: 1, **)
    patient.comorbidities.create!(
      description: create(:comorbidity_description, name: name, position: pos),
      by: user,
      **
    )
  end

  describe "#rows" do
    context "when #at_date is present and display_blank is false" do
      context "when #at_date precedes any comorbidities" do
        let(:at_date) { Date.parse("2010-01-01") }

        it "returns nothing" do
          create_comorbidity(name: "y", recognised_at: "2016-01-01", recognised: "yes")

          expect(component.rows).to be_blank
        end
      end

      context "when there are comorbidities preceding at_date and display_blank is false" do
        let(:at_date) { Date.parse("2020-01-01") }

        it "returns only those" do
          cm = create_comorbidity(name: "x", recognised_at: "2010-01-01", recognised: "yes")
          create_comorbidity(name: "y", recognised_at: "2021-01-01", recognised: "yes")

          expect(component.rows.map(&:comorbidity_id)).to eq([cm.id])
        end
      end
    end

    context "when #at_date is nil" do
      let(:at_date) { nil }

      it "returns all comorbidities" do
        cms = [
          create_comorbidity(name: "x", pos: 1, recognised_at: "2010-01-01", recognised: "yes"),
          create_comorbidity(name: "y", pos: 2, recognised_at: "2021-01-01", recognised: "yes")
        ]

        expect(component.rows.map(&:comorbidity_id)).to eq(cms.map(&:id))
      end
    end

    context "when #display_all is true" do
      let(:display_blank) { true }

      it "returns all descriptions regardless of an associated comorbidity or not" do
        cd = create(:comorbidity_description, name: "x", position: 1)
        create(:comorbidity_description, name: "y", position: 2)

        cm = patient.comorbidities.create!(
          description: cd,
          by: user,
          recognised_at: "2010-01-01",
          recognised: "yes"
        )

        expect(component.rows.map(&:name)).to eq(%w(x y))
        expect(component.rows.map(&:comorbidity_id)).to eq([cm.id, nil])
      end

      it "renders all descriptions regardless of an associated comorbidity or not" do
        cd = create(:comorbidity_description, name: "x", position: 1)
        create(:comorbidity_description, name: "y", position: 2)

        patient.comorbidities.create!(
          description: cd,
          by: user,
          recognised_at: "2010-01-01",
          recognised: "yes"
        )

        render_inline(component)
      end
    end
  end
end
