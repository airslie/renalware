module Renalware
  module Patients
    describe NHSNumberValidator, type: :validator do
      let(:out_of_range_message) { "Out of range" }
      let(:invalid_number_message) { "Invalid number" }
      let(:model_class) do
        Class.new do
          include ActiveModel::Validations
          include Virtus::Model
          attribute :nhs_number, String
          validates :nhs_number, "renalware/patients/nhs_number" => true

          def self.model_name
            ActiveModel::Name.new(self, nil, "renalware/patients/validatable")
          end
        end
      end

      describe "#validate" do
        before do
          yaml = <<-YAML
            errors:
              messages:
                nhs_number_invalid_checkdigit: "is invalid"
                nhs_number_not_numeric: "is not numeric"
          YAML
          I18n.backend.store_translations(:en, YAML.safe_load(yaml))
        end

        it "accepts a valid NHS number" do
          # Use a spread of valid numbers to make sure we excerise the algorithm reasonably
          # meaningfully
          %w(4904230000 5477425407 7465613493 9827026836 2132173117 2717073604 3477113764
             7114008236 9660350961 2637392835 1833834704 9707196408 0676304567).each do |number|
            model = model_class.new(nhs_number: number)

            expect(model).to be_valid
          end
        end

        it "rejects an invalid NHS number (final check digit incorrect as per modulus 11" do
          model = model_class.new(nhs_number: "347 711 3760")

          expect_model_to_be_invalid_with_messages(model, "is invalid")
        end

        it "rejects numbers longer than 10 characters" do
          model = model_class.new(nhs_number: "9" * 11)

          expect_model_to_be_invalid_with_messages(
            model,
            "is the wrong length (should be 10 characters)"
          )
        end

        it "rejects numbers shorter than 10 characters" do
          model = model_class.new(nhs_number: "9" * 9)

          expect_model_to_be_invalid_with_messages(
            model,
            "is the wrong length (should be 10 characters)"
          )
        end

        it "rejects numbers that contain non-digits" do
          [
            "Xxxxxxxxxx",
            "Xxx xxx xxxx",
            "X123456789",
            "X123    456789",
            "012345678x"
          ].each do |num|
            model = model_class.new(nhs_number: num)

            expect_model_to_be_invalid_with_messages(model, "is not numeric")
          end
        end

        def expect_model_to_be_invalid_with_messages(model, *expected_messages)
          errors = model.errors
          expect(model).not_to be_valid
          expect(errors.count).to eq(expected_messages.count)
          messages = errors.messages[:nhs_number]
          expect(messages & expected_messages).to eq(messages)
        end
      end
    end
  end
end
