# frozen_string_literal: true

module Renalware
  module Problems
    module Comorbidities
      # Helper class to write form params when saving a Comorbidity
      # See e.g. Comorbidities::UpdateOrRemove and ComorbiditiesController
      class Params < SimpleDelegator
        def record_exists?
          id.nonzero?
        end

        def id
          fetch(:id).to_i
        end

        def recognised_at
          fetch(:recognised_at)
        end

        def recognised_at?
          recognised_at.present?
        end

        def recognised
          fetch(:recognised, "").inquiry
        end
        delegate :unknown?, :yes?, :no?, to: :recognised

        def recognised?
          recognised.present?
        end

        def ignore?
          unknown? && !recognised_at?
        end
        alias insignificant_data? ignore?

        def malignancy_site_id = fetch(:malignancy_site_id)
      end
    end
  end
end
