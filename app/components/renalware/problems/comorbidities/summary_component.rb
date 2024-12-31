module Renalware
  module Problems
    module Comorbidities
      # Displays a list of (database defined) patient comorbidities.
      # See AR models Comorbidity and ComorbidityDescription.
      #
      # If #display_blank = true then we display all defined comorbidity descriptions and next
      # to each display the patients Yes/No + date if they have a corresponding comorbidity
      # record for this description.
      # If #display_blank = false we display the same list but only where the patient has a
      # comorbidity record - so the list could be empty or perhaps only a few.
      # If #at_date is present (eg an ESRF date) we only display comorbidities recognised on or
      # before that date.
      class SummaryComponent < ApplicationComponent
        include ToggleHelper

        pattr_initialize [
          :patient!,
          :current_user!,
          at_date: nil,
          display_blank: false
        ]

        # Returns an array of presenter objects.
        # Will return all descriptions with a matching comorbidity if there is one,
        # and filter out descriptions with no comorbidities if required
        def rows
          @rows ||= begin
            descriptions.map do |desc|
              ComorbidityPresenter.new(
                description: desc,
                comorbidity: comorbidities.detect { |cm| cm.description_id == desc.id }
              )
            end.reject { |row| row.comorbidity.blank? && !display_blank }
          end
        end

        def render?
          rows.any?
        end

        # View-model to represent a comorbidity description and its corresponding comorbidity (which
        # may be missing).
        class ComorbidityPresenter
          rattr_initialize [:description!, :comorbidity!]
          delegate :name, :snomed_code, :has_malignancy_site?, :has_diabetes_type?, to: :description
          delegate :description, to: :malignancy_site, prefix: true, allow_nil: true
          delegate :recognised_at,
                   :recognised,
                   :updated_by,
                   :updated_at,
                   :malignancy_site,
                   :diabetes_type,
                   to: :comorbidity, allow_nil: true
          delegate :id, to: :comorbidity, allow_nil: true, prefix: true
          delegate :id, :to_key, :model_name, :param_key, to: :description, allow_nil: true
        end

        private

        def comorbidities
          @comorbidities = if at_date.blank?
                             patient.comorbidities
                           else
                             patient.comorbidities.at_date(at_date)
                           end
        end

        def descriptions
          @descriptions ||= Comorbidities::Description.ordered
        end
      end
    end
  end
end
