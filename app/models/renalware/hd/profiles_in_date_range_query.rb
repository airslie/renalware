module Renalware
  module HD
    class ProfilesInDateRangeQuery
      pattr_initialize [:patient!, :from!, :to!]

      # We are looking for HD Profiles within a certain period.
      # Some HD profiles have no prescribed_on populated (and it is not always accurate - if the
      # profile is edited and a copy made, they sometimes to do not change the prescribed_on date)
      # so for the start date of the profile we always use created_at and ignore prescribed_on,
      # even if it is present.
      def call
        # If to is nil it is because modality we are targetting is a current one.
        # We need a date for the from..to range to work so use a far future one.
        @to ||= Date.parse("3000-01-01")

        # Be sure not to reselect profiles we have already used in a previous treatment otherwise
        # we will have duplicate Treatments with odd state/end date ordering
        used_profiles_ids = UKRDC::Treatment
          .where(patient: patient)
          .where.not(hd_profile_id: nil)
          .pluck(:hd_profile_id)
        HD::Profile
          .with_deactivated
          .order(created_at: :asc, deactivated_at: :desc)
          .where(patient_id: patient.id, created_at: from..to)
          .where.not(id: used_profiles_ids)
      end
    end
  end
end
