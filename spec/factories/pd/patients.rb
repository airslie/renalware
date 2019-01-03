# frozen_string_literal: true

FactoryBot.define do
  factory :pd_patient, class: "Renalware::PD::Patient", parent: :patient do
    trait :with_pd_modality do
      after(:create) do |instance|
        # This a rather clumsy approach to trying to re-use the set_modality helper
        # in PatientsSpecHelper; we can't include the module here so I am creating
        # a contrived class so I can mix in PatientsSpecHelper.
        # Other options here
        # https://github.com/thoughtbot/factory_bot/issues/564#issuecomment-157669866
        class ModalityMaker
          include PatientsSpecHelper

          def call(patient)
            set_modality(
              patient: patient,
              modality_description: FactoryBot.create(:pd_modality_description),
              by: patient.created_by
            )
          end
        end
        ModalityMaker.new.call(instance)
      end
    end
  end
end
