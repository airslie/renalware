module Renalware
  module Patients
    describe BloodPressureValidator, type: :validator do
      let(:out_of_range_message) { "out_of_range" }
      let(:must_be_less_than_systolic_message) { "must_be_less_than_systolic" }
      let(:min_value) { BloodPressureValidator::MIN_VALUE }
      let(:max_value) { BloodPressureValidator::MAX_VALUE }
      let(:model_class) do
        Class.new do
          include ActiveModel::Validations
          include Virtus::Model
          attribute :systolic, Integer
          attribute :diastolic, Integer
          validates_with BloodPressureValidator

          def self.model_name
            ActiveModel::Name.new(self, nil, "renalware/patients/blood_pressure_validatable")
          end
        end
      end

      before do
        yaml = <<-YAML
            activemodel:
              errors:
                models:
                  renalware/patients/blood_pressure_validatable:
                    attributes:
                      systolic:
                        out_of_range: #{out_of_range_message}
                      diastolic:
                        out_of_range: #{out_of_range_message}
                        must_be_less_than_systolic: #{must_be_less_than_systolic_message}
        YAML
        I18n.backend.store_translations(:en, YAML.safe_load(yaml))
      end

      it "accepts in-range values" do
        model = build_model(systolic: max_value, diastolic: min_value)
        expect(model).to be_valid
      end

      it "rejects out of range values" do
        model = build_model(systolic: min_value - 1, diastolic: min_value - 1)
        expect_model_to_be_invalid_with_messages(model, :systolic, out_of_range_message)
        expect_model_to_be_invalid_with_messages(model, :diastolic, out_of_range_message)
      end

      it "rejects non numeric values" do
        model = build_model(systolic: "NaN", diastolic: "NaN")
        expect_model_to_be_invalid_with_messages(model, :systolic, out_of_range_message)
        expect_model_to_be_invalid_with_messages(model, :diastolic, out_of_range_message)
      end

      it "fails validation if diastolic is less than systolic" do
        model = build_model(systolic: 80, diastolic: 90)
        expect_model_to_be_invalid_with_messages(model, :systolic, [])
        expect_model_to_be_invalid_with_messages(model,
                                                 :diastolic,
                                                 must_be_less_than_systolic_message)
      end

      def build_model(systolic:, diastolic:)
        model_class.new(systolic: systolic, diastolic: diastolic)
      end

      def expect_model_to_be_invalid_with_messages(model, attribute, *expected_messages)
        expect(model).not_to be_valid
        messages = Array(model.errors.messages[attribute])
        expect(messages & expected_messages).to eq(messages)
      end
    end
  end
end
