module Renalware
  module Patients
    describe BmStixValidator, type: :validator do
      let(:out_of_range_message) { "Out of range" }
      let(:invalid_number_message) { "Invalid number" }
      let(:min_value) { Patients::BmStixValidator::MIN_VALUE }
      let(:max_value) { Patients::BmStixValidator::MAX_VALUE }
      let(:model_class) do
        Class.new do
          include ActiveModel::Validations
          include Virtus::Model
          attribute :bm_stix, Float
          validates :bm_stix, "renalware/patients/bm_stix" => true

          def self.model_name
            ActiveModel::Name.new(self, nil, "renalware/patients/bm_stix_validatable")
          end
        end
      end

      describe "#validate" do
        before do
          yaml = <<-YAML
            activemodel:
              errors:
                models:
                  renalware/patients/bm_stix_validatable:
                    attributes:
                      bm_stix:
                        out_of_range: #{out_of_range_message}
                        invalid_number: #{invalid_number_message}
          YAML
          I18n.backend.store_translations(:en, YAML.safe_load(yaml))
        end

        it "accepts whole numeric values" do
          model = model_class.new(bm_stix: min_value.ceil.to_i)

          expect(model).to be_valid
        end

        it "accepts numeric values with one decimal place" do
          model = model_class.new(bm_stix: min_value + 0.1)

          expect(model).to be_valid
        end

        it "rejects valid values that have more than one decimal place" do
          model = model_class.new(bm_stix: min_value + 0.11)

          expect_model_to_be_invalid_with_messages(model, invalid_number_message)
        end

        it "rejects invalid values that have more than one decimal place" do
          model = model_class.new(bm_stix: max_value + 0.11)

          expect_model_to_be_invalid_with_messages(model,
                                                   invalid_number_message,
                                                   out_of_range_message)
        end

        it "rejects non-numeric values" do
          model = model_class.new(bm_stix: "NaN")

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        it "rejects values below the minimum" do
          model = model_class.new(bm_stix: min_value - 1.0)

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        it "rejects values above the maximum" do
          model = model_class.new(bm_stix: max_value + 1.0)

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        def expect_model_to_be_invalid_with_messages(model, *expected_messages)
          expect(model).not_to be_valid
          expect(model.errors.count).to eq(expected_messages.count)
          messages = model.errors.messages[:bm_stix]
          expect(messages & expected_messages).to eq(messages)
        end
      end
    end
  end
end
