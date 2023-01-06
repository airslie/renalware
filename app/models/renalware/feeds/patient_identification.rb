# frozen_string_literal: true

module Renalware
  module Feeds
    # Note in the PID segment internal_id == NHS number
    class PatientIdentification < SimpleDelegator
      alias_attribute :external_id, :patient_id
      alias_attribute :dob, :patient_dob
      alias_attribute :born_on, :patient_dob
      alias_attribute :died_at, :death_date

      def internal_id
        return unless defined?(patient_id_list)

        patient_id_list.split("^").first
      end

      # Given the following PID segment
      #   PID||123456789^^^NHS^ignoreme|D7006359^^^hosp1~X1234^^^hosp2|
      # this will return a hash of assigning_authority => hospital number
      # useful in the situation where we receive HL7 messages from > 1 PAS; elsewhere
      # we will map the assigning authotity to the correct patient_identitifer
      # e.g. lookup assigning_auth eg "RAJ01" in a map to discover whether we should copy this
      # patient number into local_patient_id, local_patient_2 etc
      # {
      #   "hosp1" => "D7006359",
      #   "hosp2" => "X1234"
      # }
      def hospital_identifiers
        return [] unless defined?(patient_id_list)
        return [] if patient_id_list.blank?

        @hospital_identifiers ||= begin
          patient_id_list
            .split("~")
            .each_with_object({}) do |field, hash|
              parts = field.split("^")
              hospno = parts.first
              assigning_authority = parts[3]&.to_sym
              hash[assigning_authority] = hospno
            end
        end
      end

      # Given a PID segment like this
      #   PID||123456789^^^NHS^|K123^^^HOSP1CODE^~X123^^^HOSP3CODE^|
      # where HOSP1CODE is whatever the HL7 messages uses to identify the hospital
      # (it could be e.g. "RJZ" (Kings hospital code), or e.g. "PAS Number" if there is only
      # ever one item in the HL7 patient list
      # and a Renalware.config.patient_hospital_identifiers hash like this
      #   {
      #     HOSP1: :local_patient_id,
      #     HOSP2: :local_patient_id_2,
      #     HOSP3: :local_patient_id_3
      # }
      # it returns an array of patient numbers found in the HL7 PID segment, pointing
      # for identification, in order of precendence (ie nhs_number has the highest precedence)
      # for use when finding a patient
      # e.g.
      # {
      #   nhs_number: "123456789",
      #   local_patient_id: "K123",
      #   local_patient_id_3: "X123"
      # }
      # Note at KCH there is only ever 1 hosp number and the assigning authority is "PAS Number"
      # in this case identifiers will only every contain the nhs_number.
      def identifiers
        @identifiers ||= begin
          hash = {}
          hash[:nhs_number] = nhs_number if nhs_number.present?
          Renalware.config.patient_hospital_identifiers.each do |assigning_auth, column|
            hosp_no = hospital_identifiers[assigning_auth]
            hash[column] = hosp_no if hosp_no.present?
          end

          # If the hospital uses the simple strategy like KCH, and there is just one
          # hospital number in the PID patient id list (eg with an assigning authority of
          # 'PAS Number') then make sure that value is copied into local_patient_id
          if Renalware.config.hl7_patient_locator_strategy == :simple
            hash[:local_patient_id] ||= internal_id
          end
          hash
        end
      end

      def nhs_number
        return unless defined?(patient_id)

        patient_id.split("^").first
      end

      def name
        Name.new(patient_name)
      end

      def family_name
        patient_name[0]
      end

      def given_name
        patient_name[1]
      end

      def suffix
        patient_name[3]
      end

      def title
        patient_name[4]
      end

      def address
        (super || "").split("^")
      end

      # We don't use the HL7::Message#sex_admin method (from the ruby hl7 gem) because it
      # raises an error during reading if the sex value in the PID is not in (F|M|O|U|A|N|C).
      # I think that behaviour is a not quite right as a hospital might not use those values in
      # their HL7 PID implementation, especially in the UK. KCH does not for instance.
      # So instead we read the PID array directly, and map whatever is in there to its Renalware
      # equivalent, then overwrite the existing #admin_sex method so the HL7::Message version
      # cannot be called. If we can't map it we just return whatever is in there and its up to
      # calling code to handle any coercion issues. The hl7_pid_sex_map hash can be configured
      # by the host app to support whatever sex values it uses intenrally.
      # I think some work needs to be done on Renalware sex and gender (which are slightly
      # conflated in Renalware). For example:
      # - the LOINC names for administrative sex: Male Female Unknown (https://loinc.org/72143-1/)
      # - the LOINC names for sex at birth: Male Female Unknown (https://loinc.org/LL3324-2/)
      # - HL7's definitions: F Female, M Male, O Other, U Unknown, A Ambiguous, N Not applicable
      # - gender: 7 options https://loinc.org/76691-5/
      def sex
        pid_sex = (self[8] || "").split("^")&.first&.upcase
        pid_sex ||= ""
        Renalware.config.hl7_pid_sex_map.fetch(pid_sex, pid_sex)
      end
      alias admin_sex sex

      def younger_than?(years)
        return false if born_on.blank?

        age_in_years = AgeCalculator.new.compute(
          Time.zone.parse(born_on).to_date,
          Time.zone.today
        )[:years]

        age_in_years < years
      end

      private

      def patient_name
        super.split("^")
      end
    end
  end
end
