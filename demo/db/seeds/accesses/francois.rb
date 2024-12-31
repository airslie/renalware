module Renalware
  procedure1 = procedure2 = nil
  users = User.limit(3).to_a
  patient = Accesses::Patient.find_by(local_patient_id: "Z100003")
  dummy_text = <<-TEXT.squish
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor
    sit amet, consectetur adipiscing elit."
  TEXT

  Rails.benchmark "Assign Access procedure to Francois RABBIT" do
    patient.procedures.destroy_all

    procedure1 = patient.procedures.create!(
      performed_on: 6.months.ago,
      type: Accesses::Type.all.sample,
      side: Accesses::Profile.side.values.sample,
      performed_by: users.sample,
      notes: dummy_text,
      outcome: "Perfect",
      by: users.sample
    )

    procedure2 = patient.procedures.create!(
      performed_on: 3.months.ago,
      type: Accesses::Type.all.sample,
      side: Accesses::Profile.side.values.sample,
      performed_by: users.sample,
      notes: dummy_text,
      outcome: "Perfect",
      by: users.sample
    )
  end

  Rails.benchmark "Assign Access profiles to Francois RABBIT" do
    patient = Accesses::Patient.find_by(local_patient_id: "Z100003")
    patient.profiles.destroy_all
    users = User.limit(3).to_a

    patient.profiles.create!(
      formed_on: procedure1.performed_on,
      started_on: (procedure1.performed_on - 2.months),
      terminated_on: 1.month.ago,
      type: Accesses::Type.relevant_to_access_profiles.sample,
      side: procedure1.side,
      notes: dummy_text,
      by: users.sample
    )

    patient.profiles.create!(
      patient: patient,
      formed_on: procedure2.performed_on,
      started_on: (procedure2.performed_on - 2.months),
      terminated_on: 1.week.ago,
      type: Accesses::Type.relevant_to_access_profiles.sample,
      side: procedure2.side,
      notes: dummy_text,
      by: users.sample
    )

    patient.profiles.create!(
      patient: patient,
      formed_on: 1.week.ago,
      started_on: 1.week.ago,
      type: Accesses::Type.relevant_to_access_profiles.sample,
      side: Accesses::Profile.side.values.sample,
      notes: dummy_text,
      by: users.sample
    )
  end

  Rails.benchmark "Assign Access assessments to Francois RABBIT" do
    patient = Accesses::Patient.find_by(local_patient_id: "Z100003")
    patient.assessments.destroy_all
    patient.assessments.create!(
      patient: patient,
      performed_on: procedure1.performed_on + 1.month,
      procedure_on: procedure1.performed_on,
      type: procedure1.type,
      side: procedure1.side,
      comments: dummy_text,
      by: users.sample,
      document: {
        results: {
          method: :hand_doppler,
          flow_feed_artery: "abcdef",
          has_art_stenosis: :no,
          art_stenosis_notes: dummy_text,
          has_ven_stenosis: :yes,
          ven_stenosis_notes: dummy_text,
          has_residual_stenosis: :no,
          outcome: :green
        },
        admin: {
          next_surveillance: :routine_monthly,
          decision: "Continue"
        }
      }
    )

    patient.assessments.create!(
      patient: patient,
      performed_on: procedure2.performed_on + 1.month,
      procedure_on: procedure2.performed_on,
      type: procedure2.type,
      side: procedure2.side,
      comments: dummy_text,
      by: users.sample,
      document: {
        results: {
          method: :hand_doppler,
          flow_feed_artery: "abcdef",
          has_art_stenosis: :no,
          art_stenosis_notes: dummy_text,
          has_ven_stenosis: :yes,
          ven_stenosis_notes: dummy_text,
          has_residual_stenosis: :no,
          outcome: :green
        },
        admin: {
          next_surveillance: :routine_monthly,
          decision: "Continue"
        }
      }
    )
  end
end
