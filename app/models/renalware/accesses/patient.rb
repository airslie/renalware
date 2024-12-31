module Renalware
  module Accesses
    class Patient < Renalware::Patient
      has_many :profiles, dependent: :destroy
      has_many :plans, dependent: :destroy
      has_many :procedures, dependent: :destroy
      has_many :assessments, dependent: :destroy
      has_many :needling_assessments, -> { ordered }, dependent: :destroy

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")
      def current_profile = profiles.current.first
      def current_plan = plans.current.first

      scope :with_current_plan, lambda {
        joins(<<-SQL.squish)
          left outer join access_plans on access_plans.patient_id = patients.id
            and access_plans.terminated_at is null
          left outer join access_plan_types
            on access_plans.plan_type_id = access_plan_types.id
        SQL
      }

      # Because the database allows multiple current access profiles, this scope
      # needs to choose just one, otherwise queries that merge in this scope
      # can have duplicates, or worse, broken pagination.
      scope :with_profile, lambda {
        joins(<<-SQL.squish)
          left outer join (
            select distinct on (patient_id) * from access_profiles
              where
                access_profiles.terminated_on is null
                and access_profiles.started_on <= current_date
              order by patient_id, updated_at desc
          ) access_profiles on (access_profiles.patient_id = patients.id)
          left outer join access_types on access_types.id = access_profiles.type_id
        SQL
      }
    end
  end
end
