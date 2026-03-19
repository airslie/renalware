module Renalware
  Rails.benchmark "Assigning HD Profiles to Random Patients" do
    kch_doc = User.find_by!(username: "kchdoc")
    kent_doc = User.find_by!(username: "kentdoc")
    modal_weeks = (30..50).to_a
    schedule_definitions = HD::ScheduleDefinition.all
    times = [180, 210, 240, 270]
    rates = [300, 400, 500]
    flows = [300, 400, 500]
    scheduled_times = ["09:00", "10:00", "11:00", "12:00", "13:00", "15:00", "17:00"]

    Patient.transaction do
      patients = Patient.where("family_name != 'RABBIT'")
      i = 0
      patients.each do |patient|
        i += 1
        next unless (i % 10).zero?

        patient = HD.cast_patient(patient)
        # Assign HD modality
        hd_started_on = modal_weeks.sample.weeks.ago

        Modalities::ChangePatientModality
          .new(patient: patient, user: kent_doc)
          .call(
            description: HD::ModalityDescription.first!,
            started_on: hd_started_on
          )

        # Assign some HD preferences
        preference_set = HD::PreferenceSet.find_or_initialize_by(patient: patient)
        preference_set.attributes = {
          schedule_definition: schedule_definitions.sample,
          hospital_unit: Hospitals::Unit.hd_sites.sample,
          entered_on: hd_started_on,
          by: kent_doc
        }
        preference_set.save!

        # Assign an HD profile -- NB could be further randomised
        profile = HD::Profile.find_or_initialize_by(patient: patient)
        profile.dialysate = HD::Dialysate.first
        profile.attributes = {
          by: kch_doc,
          hospital_unit: Hospitals::Unit.hd_sites.sample,
          schedule_definition: schedule_definitions.sample,
          scheduled_time: scheduled_times.sample,
          prescribed_time: times.sample,
          prescribed_on: hd_started_on,
          prescriber: kch_doc,
          transport_decider: User.last,
          document: {
            dialysis: {
              hd_type: :hd,
              cannulation_type: "Buttonhole",
              needle_size: "44",
              single_needle: :yes,
              flow_rate: rates.sample,
              blood_flow: flows.sample,
              dialyser: "FX CorDiax 120",
              potassium: 2,
              calcium: 1.5,
              temperature: 36.0,
              bicarbonate: 35,
              has_sodium_profiling: :no,
              sodium_first_half: 137,
              sodium_second_half: 145
            },
            anticoagulant: {
              type: :none,
              loading_dose: 45,
              hourly_dose: 66,
              stop_time: "0:45"
            },
            drugs: {
              on_esa: :no,
              on_iron: :no,
              on_warfarin: :no
            },
            transport: {
              has_transport: :yes,
              type: :taxi,
              decided_on: hd_started_on
            },
            care_level: {
              level: :level1,
              assessed_on: hd_started_on
            }
          }
        }
        profile.save!
      end
    end
  end
end
