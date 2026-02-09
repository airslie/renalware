module Renalware
  Rails.benchmark "Adding Histories for Roger RABBIT" do
    rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")

    rabbit.document.history.smoking = :yes
    rabbit.document.history.alcohol = :heavy
    rabbit.by = Renalware::User.last
    rabbit.save!
  end
end
