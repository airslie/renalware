module Renalware
  Rails.benchmark "Adding fake HD session" do
    units = Hospitals::Unit.hd_sites.limit(3).to_a
    users = User.limit(3).to_a
    patients = Patient.limit(10).to_a
    # start_times = ["13:00", "13:15", "13:30"]
    # end_times = ["15:30", "15:45", "16:00"]
    dates = (1..30).to_a
    dialysate_id = HD::Dialysate.first.id

    HD::Session.transaction do
      # Ongoing/not-yet signed off sessions
      20.times do
        HD::Session.create!(
          patient: HD.cast_patient(patients.sample),
          hospital_unit: units.sample,
          started_at: dates.sample.days.ago,
          signed_on_by: users.sample,
          by: users.sample
        )
      end

      session_document = {
        hdf: {
          subs_goal: 1.0,
          subs_rate: 1.0,
          subs_volume: 1.0,
          subs_fluid_pct: 1
        },
        info: {
          hd_type: "hd",
          machine_no: "123",
          access_side: "left",
          access_type: "Arteriovenous fistula (AVF)",
          access_type_abbreviation: "AVF",
          single_needle: "no",
          lines_reversed: "no",
          fistula_plus_line: "no",
          is_access_first_use: "no",
          cannulation_type: "Buttonhole",
          needle_size: "17"
        },
        dialysis: {
          flow_rate: 200,
          blood_flow: 100,
          machine_ktv: 1.0,
          machine_urr: 1,
          fluid_removed: 10.0,
          venous_pressure: 100,
          litres_processed: 10.0,
          arterial_pressure: 100
        },
        complications: {
          access_site_status: "clean_and_dry",
          line_exit_site_status: "1"
        },
        observations_after: {
          pulse: 72,
          weight: 120.0,
          bm_stix: 1.0,
          temperature: 37.0,
          blood_pressure: {
            systolic: 121,
            diastolic: 81
          }
        },
        observations_before: {
          pulse: 67,
          weight: 120.1,
          bm_stix: 1.1,
          temperature: 36.0,
          blood_pressure: {
            systolic: 120,
            diastolic: 80
          }
        }
      }

      # Closed (signed-off) sessions
      50.times do
        started_at = dates.sample.days.ago
        HD::Session::Closed.create!(
          patient: HD.cast_patient(patients.sample),
          hospital_unit: units.sample,
          started_at: started_at,
          stopped_at: started_at + 4.hours,
          signed_on_by: users.sample,
          signed_off_by: users.sample,
          by: users.sample,
          document: session_document,
          dialysate_id: dialysate_id
        )
      end
    end
  end
end
