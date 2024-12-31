module Renalware
  module Problems
    module Comorbidities
      # Service object encapsulating the logic around how to update a comorbidity submitted via
      # the form object, and whether to remove it if it is no longer significant.
      class UpdateOrRemove
        pattr_initialize [:comorbidity!, :params!, :by!]

        COLS_TO_IGNORE_WHEN_CHECKING_FOR_CHANGES = %i(
          created_at updated_at created_by_id updated_by_id
        ).freeze

        def self.call(**)
          new(**).call
        end

        # We only update comorbidities that have significant data changes
        def call
          return unless comorbidity

          if params.insignificant_data?
            remove_comorbidity
          else
            update_comorbidity
          end
        end

        private

        def remove_comorbidity
          comorbidity.destroy!
        end

        def update_comorbidity
          comorbidity.assign_attributes(params)
          changes = comorbidity.changed.reject do |attr|
            COLS_TO_IGNORE_WHEN_CHECKING_FOR_CHANGES.include?(attr.to_sym)
          end

          if changes.any?
            comorbidity.by = by
            comorbidity.save!
          end
        end
      end
    end
  end
end
