module Renalware
  module Patients
    class PatientPolicy < BasePolicy
      def update_pkb_renalreg_preferences?
        if Renalware.config.only_admins_can_update_pkb_renalreg_preferences
          user_is_any_admin?
        else
          edit?
        end
      end

      def dialysing_at_hospital?        = true
      def dialysing_at_unit?            = true

      class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user = user
          @scope = scope
        end

        # For each role define e.g. user_is_admin?
        Role::ROLES.each do |role|
          define_method :"user_is_#{role}?" do
            user.has_role?(role)
          end
        end

        # Access to a patient or patients needs to be through this scope.
        # Here we filter out patients that the current user should not be able to see - for example
        # if patients are in a private clinical study etc.
        # The need for this policy scope arose from work on the HEROIC clinical study, where there
        # were 2 sites using the same instance of Renalware - RL (the host site), and RF.
        # The specific patient access requirements for HEROIC, which now apply to all similar
        # 'private' studies, are as follows:
        #
        #   RF HEROIC user - sees HEROIC patients at RF and RL, and all non-HEROIC patients at RF
        #   RL HEROIC user - sees HEROIC patients at RL and RF and all non-HEROIC patients at RL
        #   RF non-HEROIC user - sees all non-HEROIC patients at RF
        #   RL non-HEROIC user - sees all patients at RL including HEROIC patient
        #
        # There are a few ways to implement this login in SQL.
        # Here are two:
        #
        # 1. left outer joins
        #
        # EXPLAIN ANALYSE: 0.7ms to plan and 1.3ms to execute.
        #
        #
        # select * from patients p
        # left outer join research_participations rp on rp.patient_id = p.id
        # left outer join research_studies rs on rs.id = rp.study_id
        # left outer join research_investigatorships ri on rs.id = ri.study_id and ri.user_id = 18
        # where (p.hospital_centre_id = 1 and rs.private is not true)
        # or (ri.user_id is not null and rs.private is true)
        # order by p.id
        #
        #
        # 2. where exists
        #
        # EXPLAIN ANALYSE: 1.4ms to plan and 0.9ms to execute.
        #
        # select * from patients p
        # where
        #   p.hospital_centre_id = 1
        #   and not exists(
        #     select from research_participations rp
        #       inner join research_studies rs on rs.id = rp.study_id
        #       where rs.private = true and rp.patient_id = p.id
        #     )
        # or
        #   exists (
        #     select from research_participations rp
        #     inner join research_studies rs on rs.id = rp.study_id and rs.private = true
        #     inner join research_investigatorships ri on rs.id = ri.study_id
        #     where p.id = rp.patient_id and ri.user_id = 18
        #   )
        #
        # rubocop:disable Metrics/AbcSize
        def resolve
          return if scope.nil?
          return scope.all if user_is_super_admin?

          # If the user is based at the host site e.g. Royal London they can see any patient
          # at that site including those in private studies
          # If the user is not at the host site e.g. they are at Royal Free.
          #  They can see any patients at the same site who are not in a private study
          #  They can see any patients at the same site who in a private study and the user
          #  is an investigator in that study
          # scope
          #   .joins("left outer join research_participations rp on rp.patient_id = patients.id")
          #   .joins("left outer join research_studies rs on rs.id = rp.study_id")
          #   .joins("left outer join research_investigatorships ri "\
          #         "on rs.id = ri.study_id and ri.user_id = #{user.id}")
          #   .uniq
          #   .where("(patients.hospital_centre_id = ? and rs.private is not true) "\
          #   "or (ri.user_id is not null)", user.hospital_centre_id)
          user_is_based_at_host_hospital = user.hospital_centre&.host_site?

          s = @scope.dup
          if Renalware.config.restrict_patient_visibility_by_user_site?
            @scope = @scope.where(
              default_where_sql,
              user.hospital_centre_id,
              user_is_based_at_host_hospital
            )
          end

          if Renalware.config.restrict_patient_visibility_by_research_study?
            @scope = @scope.or(
              s.where(
                research_participation_membership_where_sql,
                user.hospital_centre_id
              )
            )
            @scope = @scope.or(
              s.where(
                research_user_is_investigator_where_sql,
                user.id
              )
            )
          end
          @scope
        end
        # rubocop:enable Metrics/AbcSize

        def default_where_sql
          <<-SQL.squish
            (patients.hospital_centre_id = ? and ?)
          SQL
        end

        def research_participation_membership_where_sql
          <<-SQL.squish
            (
              (patients.hospital_centre_id = ?)
              and not exists(
                select from research_participations rp
                  inner join research_studies rs on rs.id = rp.study_id
                  where
                    patients.id = rp.patient_id
                    and rs.private = true
                    and rs.deleted_at is null
                    and rp.left_on is null
              )
            )
          SQL
        end

        def research_user_is_investigator_where_sql
          <<-SQL.squish
            exists (
              select from research_participations rp
                inner join research_studies rs on rs.id = rp.study_id
                inner join research_investigatorships ri on rs.id = ri.study_id
                where
                  patients.id = rp.patient_id
                  and ri.user_id = ?
                  and rs.deleted_at is null
                  and ri.deleted_at is null
                  and rp.deleted_at is null
                  and rp.left_on is null
            )
          SQL
        end
      end
    end
  end
end
