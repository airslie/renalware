module Renalware
  module HD
    module LetterExtensions
      class HDSection < ::Renalware::Letters::Section
        def to_partial_path
          "renalware/hd/letter_extensions/hd_section"
        end

        class << self
          def position = 10
          def description = ""
        end
      end
    end
  end
end
