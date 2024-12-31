# rubocop:disable Metrics/MethodLength
module Renalware
  patient = HD::Patient.find_by(local_patient_id: "Z100003")
  kch_doc = User.find_by!(username: "kchdoc")
  barts_doc = User.find_by!(username: "bartsdoc")
  kent_doc = User.find_by!(username: "kentdoc")
  schedule_definition = HD::ScheduleDefinition.first

  Rails.benchmark "Assign HD modality to Francois RABBIT" do
    Modalities::ChangePatientModality
      .new(patient: patient, user: kent_doc)
      .call(
        description: HD::ModalityDescription.first!,
        started_on: 1.week.ago
      )
  end

  Rails.benchmark "Assign some HD preferences to Francois RABBIT" do
    preference_set = HD::PreferenceSet.find_or_initialize_by(patient: patient)
    preference_set.attributes = {
      schedule_definition: schedule_definition,
      hospital_unit: Hospitals::Unit.hd_sites.sample,
      entered_on: 1.week.ago.to_date,
      by: barts_doc
    }
    preference_set.save!
  end

  profile = nil
  Rails.benchmark "Assign an HD profile to Francois RABBIT" do
    profile = HD::Profile.find_or_initialize_by(patient: patient)
    profile.dialysate = HD::Dialysate.first
    profile.attributes = {
      by: User.first,
      hospital_unit: Hospitals::Unit.hd_sites.first,
      schedule_definition: schedule_definition,
      prescribed_time: 180,
      prescribed_on: 1.week.ago.to_date,
      prescriber: kch_doc,
      transport_decider: barts_doc,
      document: {
        dialysis: {
          hd_type: :hd,
          cannulation_type: "Buttonhole",
          needle_size: "44",
          single_needle: :yes,
          flow_rate: 300,
          blood_flow: 400,
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
          decided_on: 2.days.ago.to_date
        },
        care_level: {
          level: :level1,
          assessed_on: 3.days.ago.to_date
        }
      }
    }
    profile.save!
  end

  dry_weight = nil

  Rails.benchmark "Create dry weight to Francois RABBIT" do
    dry_weight = Clinical::DryWeight.find_or_create_by(
      patient: Renalware::Clinical.cast_patient(patient),
      weight: 98.6,
      assessed_on: Time.zone.now,
      assessor_id: Renalware::User.third.id,
      created_by_id: Renalware::User.third.id
    )
  end

  Rails.benchmark "Assign HD sessions to Francois RABBIT" do
    units = Hospitals::Unit.hd_sites.limit(3).to_a
    users = User.limit(3).to_a
    # start_times = ["13:00", "13:15", "13:30"]
    # end_times = ["15:30", "15:45", "16:00"]
    dialysate_id = HD::Dialysate.first.id

    # rubocop:disable Metrics/AbcSize
    def self.session_document
      {
        info: {
          hd_type: "hd",
          machine_no: rand(100..222),
          access_confirmed: true,
          access_side: "right",
          access_type: "Axillary axillary cross-over PTFE Graft",
          access_type_abbreviation: "AVG UO",
          single_needle: "no",
          lines_reversed: "no",
          fistula_plus_line: "no",
          is_access_first_use: "no",
          cannulation_type: "Buttonhole",
          needle_size: "17"
        },
        dialysis: {
          flow_rate: rand(100..200),
          blood_flow: rand(100..200),
          machine_ktv: rand(0.5..3.0).round(1),
          machine_urr: rand(0.6..10.0).round(1),
          fluid_removed: rand(1.0..10.0).round(1),
          venous_pressure: rand(100..200),
          litres_processed: rand(10.0..20.0).round(1),
          arterial_pressure: rand(5..10)
        },
        avf_avg_assessment: {
          score: 1
        },
        observations_after: {
          pulse: rand(60..80),
          weight: rand(110.0..112.0).round(1),
          bm_stix: rand(0.6..10.0).round(1),
          temperature: rand(36..38),
          respiratory_rate: 40,
          blood_pressure: {
            systolic: rand(100..120),
            diastolic: rand(80..99)
          }
        },
        observations_before: {
          pulse: rand(60..80),
          weight: rand(106.0..110.0).round(1),
          bm_stix: rand(0.6..10.0).round(1),
          temperature: rand(36..38),
          respiratory_rate: 40,
          blood_pressure: {
            systolic: rand(100..120),
            diastolic: rand(80..99)
          }
        },
        complications: {
          access_site_status: "clean_and_dry",
          line_exit_site_status: "1"
        }
      }
    end
    # rubocop:enable Metrics/AbcSize

    # Make the most recent session ongoing
    HD::Session::Open.create!(
      patient_id: patient.id,
      hospital_unit: units.sample,
      started_at: Time.zone.today,
      signed_on_by: users.sample,
      by: users.sample
    )

    # Create some closed and dna sessions on random dates over the past 6 years
    50.times do |i|
      date = rand(6.months).seconds.ago

      # She misses every 5th session
      if i % 5 == 0
        HD::Session::DNA.create!(
          patient_id: patient.id,
          hospital_unit: units.sample,
          started_at: date,
          signed_on_by: users.sample,
          by: users.sample,
          notes: "",
          document: {
            patient_on_holiday: "yes"
          }
        )
      else
        # TODO: call SaveSession here?
        HD::Session::Closed.create!(
          patient_id: patient.id,
          hospital_unit: units.sample,
          started_at: date,
          stopped_at: date + 3.hours,
          signed_on_by: users.sample,
          signed_off_at: date,
          signed_off_by: users.sample,
          by: users.sample,
          document: session_document,
          dialysate_id: dialysate_id,
          dry_weight_id: dry_weight.id,
          profile_id: profile.id
        )
      end
    end
  end

  Rails.benchmark "Generate HD statistics for the last 6 months of HD Sessions" do
    # Generate HD statistics for the last 6 months of HD Sessions, starting with last month - we
    # don't do monthly stats for the current month
    (1..6).each do |month|
      date = Time.zone.today - month.months
      period = MonthPeriod.new(month: date.month, year: date.year)
      HD::GenerateMonthlyStatisticsForPatient.new(patient: patient,
                                                  period: period).call
    end

    # Update the rolling HD statistics
    HD::UpdateRollingPatientStatistics.new(patient: patient).call
  end
end
# rubocop:enable Metrics/MethodLength
