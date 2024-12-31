FactoryBot.define do
  factory :hd_patient, class: "Renalware::HD::Patient", parent: :patient do
    trait :with_hd_modality do
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
              modality_description: FactoryBot.create(:hd_modality_description),
              by: patient.created_by
            )
          end
        end
        ModalityMaker.new.call(instance)
      end
    end
  end
end
