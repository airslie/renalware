module Renalware
  extend SeedsHelper

  Rails.benchmark "Adding Clinic Visits for Roger RABBIT" do
    rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")

    without_papertrail_versioning_for(Clinics::ClinicVisit) do
      5.times do |n|
        user = User.first
        Clinics::ClinicVisit.find_or_create_by!(
          patient_id: rabbit.id,
          clinic: Clinics::Clinic.order("RANDOM()").first,
          height: 1.25,
          weight: 55 + n,
          systolic_bp: 110 + n,
          diastolic_bp: 68 + n,
          date: n.days.ago.change({ hour: (10 + (2 * n)), min: 0 })
        ) do |cv|
          cv.by = user
        end
      end
    end
  end
end
