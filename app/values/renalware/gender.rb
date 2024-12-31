module Renalware
  class Gender
    include ActiveModel::Model
    attr_reader :code

    DATA = {
      "NK" => "Not Known",
      "M" => "Male",
      "F" => "Female",
      "NS" => "Not Specified"
    }.freeze

    SALUTATIONS = {
      "NK" => "",
      "M" => "Mr",
      "F" => "Ms",
      "NS" => ""
    }.freeze

    NHS_DICTIONARY_NUMBERS = {
      "NK" => 0,
      "M" => 1,
      "F" => 2,
      "NS" => 9
    }.freeze

    NHS_DICTIONARY_VALUES = {
      "0" => "NK",
      "1" => "M",
      "2" => "F",
      "9" => "NS"
    }.freeze

    def self.all
      DATA.map { |code, _| new(code) }
    end

    # @section serialization
    #
    def self.load(raw_string)
      new(raw_string)
    end

    def self.dump(gender)
      gender.to_str
    end

    def initialize(code)
      @code = code && ActiveSupport::StringInquirer.new(code)
    end

    # @section validations
    #
    validates :code, inclusion: { in: DATA.keys }

    # @section attributes
    #

    def name
      DATA[code]
    end

    def salutation
      SALUTATIONS[code]
    end

    def nhs_dictionary_number
      NHS_DICTIONARY_NUMBERS[code]
    end

    # @section coercions
    #
    def to_s
      code || ""
    end

    def to_str
      code
    end
  end
end
