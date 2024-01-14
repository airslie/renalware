# frozen_string_literal: true

module Renalware
  module Modalities
    class ModalityPolicy < BasePolicy
      def edit?
        Renalware.config.allow_modality_history_amendments && user_is_at_least_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
