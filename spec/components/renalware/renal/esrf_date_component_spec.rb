# frozen_string_literal: true

# rubocop:disable RSpec/PredicateMatcher
describe Renalware::Renal::ESRFDateComponent, type: :component do
  let(:esrf_on) { nil }
  let(:profile) { create(:renal_profile, patient: patient, esrf_on: esrf_on) }
  let(:patient) do
    create(:renal_patient).tap do |pat|
      # Make url generation work for patients
      allow(pat).to receive(:to_param).and_return("1")
    end
  end

  before { patient && profile }

  def change_current_modality(patient:, code:)
    modality_desc = instance_double(Renalware::Modalities::Description, code: code)
    modality = instance_double(Renalware::Modalities::Modality, description: modality_desc)
    allow(patient).to receive(:current_modality).and_return(modality)
  end

  context "when the patient's current modality expects an ESFR date to be present" do
    %w(hd pd transplant).each do |modality_code|
      before { change_current_modality(patient: patient, code: modality_code) }

      context "when the ESRF date is missing" do
        it "displays a warning" do
          component = described_class.new(patient: patient)

          render_inline(component).to_html

          expect(page).to have_content "ESRF:Missing"
        end
      end

      context "when the ESRF date is present" do
        let(:esrf_on) { "2018-01-01" }

        it "renders the date" do
          component = described_class.new(patient: patient)

          render_inline(component).to_html

          expect(page).to have_content "ESRF:01-Jan-2018"
        end
      end
    end
  end

  context "when the patient's current modality does not expect an ESRF date" do
    %w(akcc).each do |modality_code|
      before { change_current_modality(patient: patient, code: modality_code) }

      context "when the ESRF date is missing" do
        let(:esrf_on) { nil }

        it "renders nothing" do
          component = described_class.new(patient: patient)

          expect(component.render?).to be_falsey
        end
      end

      context "when the ESRF date is present" do
        let(:esrf_on) { "2018-01-01" }

        it "renders the date" do
          component = described_class.new(patient: patient)

          render_inline(component).to_html

          expect(page).to have_content "ESRF:01-Jan-2018"
        end
      end
    end
  end

  context "when the patient has no current modality" do
    context "when the ESRF date is missing" do
      let(:esrf_on) { nil }

      it "renders nothing" do
        component = described_class.new(patient: patient)

        expect(component.render?).to be_falsey
      end
    end

    context "when the ESRF date is present" do
      let(:esrf_on) { "2018-01-01" }

      it "renders the date" do
        component = described_class.new(patient: patient)

        render_inline(component).to_html

        expect(page).to have_content "ESRF:01-Jan-2018"
      end
    end
  end
end
# rubocop:enable RSpec/PredicateMatcher
