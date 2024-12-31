module Renalware
  module HD
    class Patient < Renalware::Patient
      has_one :hd_profile, class_name: "Profile"
      has_many :vnd_risk_assessments
      has_one :hd_preference_set, class_name: "PreferenceSet"
      has_many :hd_sessions, class_name: "Session"
      has_many :prescription_administrations
      has_many :patient_statistics
      has_one :rolling_patient_statistics, lambda {
                                             merge(PatientStatistics.rolling)
                                           }, class_name: "PatientStatistics"

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      scope :with_profile, lambda {
        includes(hd_profile: :hospital_unit)
          .joins(<<-SQL.squish)
            LEFT OUTER JOIN hd_profiles ON hd_profiles.patient_id = patients.id
            LEFT OUTER JOIN hospital_units ON hd_profiles.hospital_unit_id = hospital_units.id
          SQL
          .where("hd_profiles.deactivated_at is NULL")
      }

      def treated?
        modality_descriptions.exists?(type: "Renalware::HD::ModalityDescription")
      end

      def has_ever_been_on_hd?
        @has_ever_been_on_hd ||=
          modality_descriptions.exists?(type: "Renalware::HD::ModalityDescription")
      end

      def current_modality_hd?
        return false if current_modality.blank?

        current_modality.description.is_a?(HD::ModalityDescription)
      end

      def __getobj__
        self
      end
    end
  end
end
