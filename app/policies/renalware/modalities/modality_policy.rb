module Renalware
  module Modalities
    class ModalityPolicy < BasePolicy
      def edit?
        Renalware.config.allow_modality_history_amendments && user_is_any_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
