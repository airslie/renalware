require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Once < Frequency
        def self.exceeds?(_days)
          false
        end
      end
    end
  end
end
