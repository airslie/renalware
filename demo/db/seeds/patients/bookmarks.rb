module Renalware
  Rails.benchmark "Adding Bookmarks" do
    return if Patients::Bookmark.any?

    roger_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    jessica_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Jessica")
    francois_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "François")
    bookmarks = []

    Patient.transaction do
      [roger_rabbit, jessica_rabbit, francois_rabbit].each do |patient|
        User.pluck(:id).each do |user_id|
          bookmarks << {
            user_id: user_id,
            patient_id: patient.id,
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          }
        end
      end
    end
    Patients::Bookmark.insert_all(bookmarks)
  end
end
