module Renalware
  Rails.benchmark "Adding Events for Roger RABBIT" do
    rabbit = Patient.find_by!(family_name: "RABBIT", given_name: "Roger")

    Events::Simple.find_or_create_by!(
      patient_id: rabbit.id,
      event_type_id: 19,
      description: "meeting with family in clinic",
      notes: "anxious about medication changes",
      date_time: Time.zone.now - 2.weeks,
      created_by_id: Renalware::User.first.id,
      updated_by_id: Renalware::User.first.id
    )

    Events::Simple.find_or_create_by!(
      patient_id: rabbit.id,
      event_type_id: 25,
      description: "call regarding meds",
      notes: "told patient to get other drug info from GP",
      date_time: Time.zone.now - 12.days,
      created_by_id: Renalware::User.second.id,
      updated_by_id: Renalware::User.second.id
    )

    Events::Simple.find_or_create_by!(
      patient_id: rabbit.id,
      event_type_id: 8,
      description: "email re next clinic visit",
      notes: "reminded patient to bring complete drug list to clinic",
      date_time: Time.zone.now - 5.days,
      created_by_id: Renalware::User.last.id,
      updated_by_id: Renalware::User.last.id
    )

    Events::Simple.find_or_create_by!(
      patient_id: rabbit.id,
      event_type_id: Events::Type.find_by!(slug: "iron_clinic").id,
      description: "email re next clinic visit",
      notes: "reminded patient to bring complete drug list to clinic",
      date_time: Time.zone.now - 5.days,
      created_by_id: Renalware::User.last.id,
      updated_by_id: Renalware::User.last.id
    )
  end
end
