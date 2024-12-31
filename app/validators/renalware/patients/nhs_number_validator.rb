module Renalware
  module Patients
    # Validates an NHS number which should be 10 characters long and confirm to the modulo 11
    # algorithm where the 10th character is a check digit.
    class NHSNumberValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.blank?

        Validator.new(record, attribute, value).validate
      end

      class Validator
        pattr_initialize :record, :attribute, :number
        LENGTH = 10

        def validate
          strip_spaces_from_nhs_number
          validate_length
          validate_numeric
          validate_using_modulus_11
        end

        private

        def strip_spaces_from_nhs_number
          @record[attribute] = @number = @number.delete(" ")
        end

        def validate_length
          ActiveModel::Validations::LengthValidator.new(
            is: LENGTH,
            attributes: [attribute]
          ).validate(record)
        end

        def validate_numeric
          return if record.errors[attribute].any?

          unless number =~ /\d{10}/
            record.errors.add(attribute, :nhs_number_not_numeric)
          end
        end

        # See https://www.datadictionary.nhs.uk/data_dictionary/attributes/n/nhs/nhs_number_de.asp
        # rubocop:disable Metrics/AbcSize
        def validate_using_modulus_11
          return if record.errors[attribute].any?

          # Step 1 Multiply each of the first nine digits by a weighting factor
          # Digit Position  Factor
          # 1                10
          # 2                9
          # 3                8
          # 4                7
          # 5                6
          # 6                5
          # 7                4
          # 8                3
          # 9                2
          weighting_factors = [10, 9, 8, 7, 6, 5, 4, 3, 2]
          first_9_digits = number.chars.map(&:to_i).take(9)
          first_9_digits_weighted = first_9_digits.each_with_index.map do |num, idx|
            num * weighting_factors[idx]
          end

          # Step 2 Add the results of each multiplication together.
          # Step 3 Divide the total by 11 and establish the remainder.
          # Step 4 Subtract the remainder from 11 to give the check digit.
          checkdigit = 11 - (first_9_digits_weighted.sum % 11)

          # If the result is 11 then a check digit of 0 is used.
          checkdigit = 0 if checkdigit == 11

          # If the result is 10 then the NHS NUMBER is invalid and not used.
          # Step 5 Check the remainder matches the check digit. Otherwise the NHS NUMBER is invalid.
          if checkdigit == 10 || number[9].to_i != checkdigit
            record.errors.add(attribute, :nhs_number_invalid_checkdigit)
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
      private_constant :Validator
    end
  end
end
