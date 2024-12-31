module Renalware
  module Patients
    class NagsComponent < ApplicationComponent
      rattr_initialize [:patient!, :current_user!]

      def definitions
        @definitions ||= System::NagDefinition.where(enabled: true).order(:importance).take(5)
      end

      def render?
        definitions.any?
      end
    end
  end
end
