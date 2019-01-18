# frozen_string_literal: true

log "Adding Research Studies" do
  unless Renalware::Research::Study.exists?
    user = Renalware::User.last
    patient_id_groups = Renalware::Patient.limit(12).pluck(:id).in_groups_of(3)

    patient_id_groups.each_with_index do |patient_ids, idx|
      last_study = (idx + 1) == patient_id_groups.length
      started_on = (idx + 1).years.ago
      terminated_on = last_study ? started_on + 3.months : nil

      Renalware::Research::Study.create!(
        code: "#{Faker::Name.initials}#{SecureRandom.hex(5).upcase}",
        description: Faker::Company.catch_phrase,
        leader: Faker::Name.name,
        notes: Faker::Lorem.sentence(12),
        started_on: started_on,
        terminated_on: terminated_on,
        by: user
      ).tap do |study|

        patient_ids.each_with_index do |patient_id, patient_idx|
          joined_on = study.started_on + idx.weeks
          left_on = patient_idx.zero? ? joined_on + idx.months : nil
          study.participations.create!(
            patient_id: patient_id,
            joined_on: joined_on,
            left_on: left_on,
            by: user
          )
        end
      end
    end
  end
end
