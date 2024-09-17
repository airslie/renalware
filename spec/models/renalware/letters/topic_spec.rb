# frozen_string_literal: true

module Renalware
  module Letters
    describe Topic do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of :text }

      describe "Sections" do
        describe ".letter_extension_sections" do
          it "has a default value" do
            expect(described_class.letter_extension_sections).to eq \
              [
                Renalware::HD::LetterExtensions::HDSection
              ]
          end
        end

        describe ".sections_by_identifier" do
          it "groups sections by identifier" do
            expect(described_class.sections_by_identifier).to eq \
              hd_section: Renalware::HD::LetterExtensions::HDSection
          end
        end

        describe "#section_identifiers" do
          let(:instance) { described_class.new }

          it { expect(instance.sections).to eq [] }

          context "with section identifiers set" do
            let(:instance) { described_class.new(section_identifiers: [:hd_section]) }

            it "groups sections by identifiers" do
              expect(instance.sections).to eq \
                [
                  Renalware::HD::LetterExtensions::HDSection
                ]
            end
          end
        end
      end
    end
  end
end
