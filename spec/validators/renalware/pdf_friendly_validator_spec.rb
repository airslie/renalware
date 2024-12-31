module Renalware
  describe PdfFriendlyValidator, type: :validator do
    describe "validate" do
      let(:model_class) do
        Class.new do
          include ActiveModel::Validations
          include Virtus::Model
          attribute :content, String
          validates :content, "renalware/pdf_friendly": true

          def self.model_name
            ActiveModel::Name.new(self, nil, Time.zone.now.to_i.to_s)
          end
        end
      end

      context "when contains non-Windows-1252 characters that cannot be converted to UTF-8" do
        subject(:model) { model_class.new(content: "☐") }

        it :aggregate_failures do
          is_expected.not_to be_valid
          expect(model.errors[:content]).not_to be_blank
        end
      end

      context "when contains Windows-1252 characters that can be converted to UTF-8" do
        subject(:model) { model_class.new(content: "♣") }

        it :aggregate_failures do
          is_expected.to be_valid
          expect(model.errors.key?(:content)).to be(false)
        end
      end
    end
  end
end
