require "ap"

module Renalware::Feeds
  describe PatientLocatorStrategies::Dynamic do
    defaults = {
      nhs_number: { hl7: "0909718644", rw: "0909718644" },
      local_patient_id: { hl7: "A1", rw: "A1" },
      dob: { hl7: "01-01-1980", rw: "01-01-1980" }
    }

    [
      {
        comment: "1. Matches on NHS and MRN, DOB different, will update DOB in RW",
        dob: { rw: "02-01-1980" },
        local_patient_id_2: { rw: "C123" },
        found: true
      },
      {
        comment: "2. Match on NHS+MRN (DOB would too but not needed in this instance)",
        local_patient_id_2: { hl7: "ABC" },
        found: true
      },
      {
        comment: "3. Matches on NHS and DOB but MRN mismatch suggesting duplicate patient",
        local_patient_id: { rw: "B1" },
        error: "Possible duplicate"
      },
      {
        comment: "4. Match on MRN and DOB when no NHS in HL7",
        nhs_number: { hl7: "" },
        found: true
      },
      {
        comment: "5. Match on MRN and DOB when NHS in HL7 num not found in RW; updates NHS",
        nhs_number: { rw: "" },
        found: true
      },
      {
        comment: "6. No match - No DOB or NHS in HL7, MRN matches though but its not enough",
        nhs_number: { hl7: "" },
        dob: { hl7: "" },
        found: false
      },
      {
        comment: "7. Poss dupe: No NHS in HL7, MRN matches but DOB does not",
        nhs_number: { hl7: "" },
        dob: { hl7: "01/01/1980", rw: "02/02/1980" },
        error: "Possible duplicate"
      },
      {
        comment: "8. Only DOB matches",
        nhs_number: { hl7: "" },
        dob: { hl7: "" },
        found: false
      },
      {
        comment: "9. Matches on NHS and DOB but not MRN as it is missing in RW; updates MRN",
        local_patient_id: { hl7: "123", rw: "" },
        found: true
      },
      {
        comment: "10. No NHS in HL& and RW bur MRN and DOB match",
        nhs_number: { hl7: "", rw: "" },
        found: true
      },
      {
        comment: "11. NHS and MRN differ, DOB same;",
        nhs_number: { hl7: "0909718644", rw: "8555176921" },
        local_patient_id: { hl7: "A1", rw: "B1" },
        found: false
      },
      {
        comment: "13. NHS and DOB same, no MRNs either side;",
        local_patient_id: { hl7: "", rw: "" },
        found: true
      }
    ].each do |scenarios_overrides|
      hash = defaults.deep_merge(scenarios_overrides)
      it hash[:comment] do
        patient = create_patient(hash)
        _other_patient = create_other_patient
        pi = create_pi(hash)
        result = nil
        if hash[:error].present?
          expect {
            result = described_class.call(patient_identification: pi)
          }.to raise_error(
            PatientLocatorStrategies::Dynamic::Error,
            /duplicate/
          )
        else
          result = described_class.call(patient_identification: pi)
          p scenarios_overrides
          if scenarios_overrides[:found] == true
            expect(result).to eq(patient)
          else
            expect(result).to be_nil
          end
        end
      end
    end

    def create_pi(hash, **identifiers)
      identifiers = identifiers.compact_blank
      identifiers[:nhs_number] ||= hash.dig(:nhs_number, :hl7)
      identifiers[:local_patient_id] ||= hash.dig(:local_patient_id, :hl7)
      identifiers[:local_patient_id_2] ||= hash.dig(:local_patient_id_2, :hl7)
      instance_double(
        Renalware::Feeds::PatientIdentification,
        born_on: hash.dig(:dob, :hl7),
        identifiers: identifiers.to_h,
        nhs_number: identifiers[:nhs_number]
      )
    end

    def create_patient(hash, **)
      build(
        :patient,
        nhs_number: hash.dig(:nhs_number, :rw),
        local_patient_id: hash.dig(:local_patient_id, :rw),
        born_on: hash.dig(:dob, :rw),
        **
      ).tap { |u| u.save(validate: false) }
    end

    def create_other_patient(**) = create(:patient, **)

    def hash_diff(ha, hb)
      ha
        .reject { |k, v| hb[k] == v }
        .merge!(hb.reject { |k, _v| ha.key?(k) })
    end

    it "2 patients with same nhs number and dob and no local_patient_id" do
      build(:patient, nhs_number: "0909718644", local_patient_id: nil, born_on: "2000-01-01")
        .tap { |u| u.save(validate: false) }
      build(:patient, nhs_number: "0909718644", local_patient_id: nil, born_on: "2000-01-01")
        .tap { |u| u.save(validate: false) }

      pi = instance_double(
        Renalware::Feeds::PatientIdentification,
        born_on: "2000-01-01",
        identifiers: {},
        nhs_number: "0909718644"
      )
      expect {
        described_class.call(patient_identification: pi)
      }.to raise_error(PatientLocatorStrategies::Dynamic::Error, /Possible duplicate/)
    end
  end
end
