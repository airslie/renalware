require_dependency "renalware/letters"

module Renalware
  module Letters
    class ClinicLetter < BaseLetter
      belongs_to :clinic_visit
      validates_presence_of :clinic_visit_id

      def self.policy_class
        BasePolicy
      end

    end
  end
end