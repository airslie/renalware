module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at MSE for ADT HL7 messages.
      class Dynamic
        include Callable

        class Error < StandardError; end

        pattr_initialize [:patient_identification!, relation: Renalware::Patient.where("1=1")]
        delegate :identifiers, to: :patient_identification
        delegate :nhs_number, to: :patient_identification

        def call
          patient = nil

          if msg_contains_nhs_number?
            patient = if nhs_number_exists_in_rw?
                        find_patient_by_nhs_and_mrn || find_patient_by_nhs_and_dob
                      else
                        find_patient_by_dob_and_mrn
                      end
          elsif msg_contains_dob?
            patient = find_patient_by_dob_and_mrn
            if patient.nil? && find_by_mrn.any?
              raise(
                Error,
                "Possible duplicate - not found using DOB + MRN, but found using just the MRN"
              )
            end
          end

          patient
        end

        def find_patient_by_nhs_and_mrn
          return unless local_patient_id_identifiers?
          return unless msg_contains_nhs_number?

          patients = find_by_nhs_and_mrn
          raise(Error, "Possible duplicate matching NHS + MRN") if patients.length > 1

          patients.first
        end

        def find_patient_by_nhs_and_dob
          return unless msg_contains_dob?
          return unless msg_contains_nhs_number?

          patients = find_by_nhs_and_dob
          patient = patients.first
          raise(Error, "Possible duplicate matching NHS + DOB") if patients.length > 1
          if relevant_identifiers_differ_for?(patient)
            raise(Error, "Possible duplicate - matching NHS + DOB but MRN in RW differs ")
          end

          patient
        end

        def find_patient_by_dob_and_mrn
          return unless msg_contains_dob?
          return unless local_patient_id_identifiers?

          patients = find_by_dob_and_mrn
          raise(Error, "Possible duplicate matching DOB + MRN") if patients.length > 1

          patients.first
        end

        # Omit where the patient has a blank identifier eg local_patient_id = nil or ""
        def relevant_identifiers_differ_for?(patient)
          local_patient_id_identifiers
            .any? do |key, val|
              patient.send(key).present? && patient.send(key) != val
            end
        end

        def find_by_nhs_and_mrn
          Renalware::Patient
            .where(nhs_number: nhs_number)
            .merge(match_on_any_mrn)
        end

        def find_by_nhs_and_dob
          Renalware::Patient
            .where(nhs_number: nhs_number)
            .where(born_on: born_on)
        end

        def find_by_mrn
          Renalware::Patient.merge(match_on_any_mrn)
        end

        def find_by_dob_and_mrn
          Renalware::Patient
            .where(born_on: born_on)
            .merge(match_on_any_mrn)
        end

        def match_on_any_mrn(rel = Patient.where("1=1"))
          local_patient_id_identifiers.each.with_index do |identifier, idx|
            column, hosp_no = identifier
            rel = if idx.zero?
                    Patient.where(column => hosp_no)
                  else
                    rel.or(Patient.where(column => hosp_no))
                  end
          end
          rel
        end

        def nhs_number? = nhs_number.present?
        def msg_contains_nhs_number? = nhs_number.present?
        def born_on? = born_on.present?
        def msg_contains_dob? = born_on.present?
        def nhs_number_exists_in_rw? = Renalware::Patient.exists?(nhs_number: nhs_number)
        def local_patient_id_identifiers = identifiers.except(:nhs_number).compact_blank
        def local_patient_id_identifiers? = local_patient_id_identifiers.any?

        def reset_relation
          self.relation = Renalware::Patient.all
        end

        def match_on_dob
          raise(Error, "cannot match on DOB is there is none") if born_on.blank?

          self.relation = relation.where(born_on: born_on)
        end

        def match_on_nhs_number
          self.relation = relation.where(nhs_number: nhs_number)
        end

        def match_on_any_local_patient_id
          unless local_patient_id_identifiers?
            raise(Error, "cannot match on hosp numbers as there are none")
          end

          local_patient_id_identifiers.each do |column, hosp_no|
            self.relation = relation.where(column => hosp_no)
          end
        end

        def born_on
          Date.parse(patient_identification.born_on) if patient_identification.born_on.present?
        end

        private

        attr_accessor :relation
      end
    end
  end
end
