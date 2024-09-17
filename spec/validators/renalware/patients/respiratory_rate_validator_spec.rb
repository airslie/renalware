# frozen_string_literal: true

module Renalware
  module Patients
    describe RespiratoryRateValidator, type: :validator do
      let(:out_of_range_message) { "Out of range" }
      let(:invalid_number_message) { "Invalid number" }
      let(:min_value) { Patients::RespiratoryRateValidator::MIN_VALUE }
      let(:max_value) { Patients::RespiratoryRateValidator::MAX_VALUE }
      let(:model_class) do
        Class.new do
          include ActiveModel::Validations
          include Virtus::Model
          attribute :respiratory_rate, Integer
          validates :respiratory_rate, "renalware/patients/respiratory_rate" => true

          def self.model_name
            ActiveModel::Name.new(self, nil, "renalware/patients/respiratory_rate_validatable")
          end
        end
      end

      describe "#validate" do
        before do
          yaml = <<-YAML
            activemodel:
              errors:
                models:
                  renalware/patients/respiratory_rate_validatable:
                    attributes:
                      respiratory_rate:
                          out_of_range: #{out_of_range_message}
                          invalid_number: #{invalid_number_message}
          YAML
          I18n.backend.store_translations(:en, YAML.safe_load(yaml))
        end

        it "accepts whole numeric values" do
          model = model_class.new(respiratory_rate: min_value.ceil.to_i)

          expect(model).to be_valid
        end

        it "rejects non-numeric values" do
          model = model_class.new(respiratory_rate: "NaN")

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        it "rejects values below the minimum" do
          model = model_class.new(respiratory_rate: min_value - 1.0)

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        it "rejects values above the maximum" do
          model = model_class.new(respiratory_rate: max_value + 1.0)

          expect_model_to_be_invalid_with_messages(model, out_of_range_message)
        end

        def expect_model_to_be_invalid_with_messages(model, *expected_messages)
          expect(model).not_to be_valid
          expect(model.errors.count).to eq(expected_messages.count)
          messages = model.errors.messages[:respiratory_rate]
          expect(messages & expected_messages).to eq(messages)
        end
      end
    end
  end
end
