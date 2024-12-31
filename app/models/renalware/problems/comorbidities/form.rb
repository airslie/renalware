module Renalware
  module Problems
    module Comorbidities
      # Form object to allow editing and updating of a set of patient comorbidities.
      # Used
      # a) as a AM model when building the form
      # b) as the 'thing' to save when the form is submitted.
      class Form
        include ActiveModel::Model
        rattr_initialize [:patient!, :by, params: {}]
        delegate :comorbidities, to: :patient, prefix: true

        def descriptions
          @descriptions ||= Comorbidities::Description.ordered
        end

        def comorbidities
          @comorbidities ||= begin
            descriptions.map do |description|
              como = patient_comorbidities.detect { |com| com.description == description }
              como || patient_comorbidities.new(description: description) # empty record
            end
          end
        end

        def save
          Comorbidity.transaction do
            params[:comorbidities_attributes].each_value do |args|
              cparams = Comorbidities::Params.new(args)
              if cparams.record_exists?
                comorb = patient_comorbidities.detect { |cm| cm.id == cparams.id }
                Comorbidities::UpdateOrRemove.call(comorbidity: comorb, params: cparams, by: by)
              else
                next if cparams.ignore?

                patient_comorbidities.create!(by: by, **args)
              end
            end
          end
        end

        # Need to be defined for the form builder to work with #fields_for
        def comorbidities_attributes=(params); end
      end
    end
  end
end
