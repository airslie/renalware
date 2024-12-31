module Renalware
  module UKRDC
    module TreatmentTimeline
      describe GeneratorFactory do
        describe ".call" do
          subject { described_class.call(modality) }

          let(:patient) { build_stubbed(:patient) }
          let(:modality) { build_stubbed(:modality, description: description, patient: patient) }

          context "when the supplied modality has no explicit type" do
            let(:description) { build_stubbed(:modality_description, name: "X", code: nil) }

            it { is_expected.to be_a(Generic::Generator) }
          end

          context "when the supplied modality description returns has a non-nil code" do
            context "when a generator exists for that code e.g. 'hd'" do
              let(:description) { build_stubbed(:hd_modality_description, code: "hd") }

              it "maps the code to a corresponding generator" do
                is_expected.to be_a(Renalware::UKRDC::TreatmentTimeline::HD::Generator)
              end
            end

            context "when no generator exists for the code eg 'made_up'" do
              let(:description) { build_stubbed(:modality_description, code: "made_up") }

              it "defaults to using a generic generator" do
                is_expected.to be_a(Renalware::UKRDC::TreatmentTimeline::Generic::Generator)
              end
            end
          end
        end
      end
    end
  end
end
