module Renalware
  user = User.find_by!(username: "kchdoc")
  rabbit = Patient.find_by!(family_name: "RABBIT", given_name: "Roger")

  Rails.benchmark "Adding Demographics for Roger RABBIT" do
    rabbit.title = "Mr"
    rabbit.suffix = "OBE"
    rabbit.marital_status = "divorced"
    rabbit.telephone1 = "0201 555 1212"
    rabbit.email = "rogerrabbit@rmail.co.uk"
    rabbit.religion = Renalware::Patients::Religion.second!
    rabbit.language = Renalware::Patients::Language.first!
    rabbit.by = user
    rabbit.document = {
      referral: {
        referral_date: 1.week.ago,
        referral_type: "Urgent",
        referral_notes: "NB family friend of referrer",
        referring_physician_name: "Dr Jack L N Hyde"
      },
      admin_notes: "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
      interpreter_notes: "Second language French",
      special_needs_notes: "Lorem ipsum dolor sit amet"
    }
    rabbit.named_nurse = User.find_by!(username: "kentnurse")
    rabbit.save!
  end

  system_user = SystemUser.find

  Rails.benchmark "Adding Primary Care Physician for Roger RABBIT" do
    practice = Patients::Practice.first!

    pcp = Patients::PrimaryCarePhysician.find_or_create_by!(code: "G1234567") do |doc|
      doc.name = "MERRILL J"
      doc.practitioner_type = "GP"
      doc.practices << practice
    end

    rabbit.primary_care_physician = pcp
    rabbit.practice = practice
    rabbit.by = system_user
    rabbit.save!
  end

  Rails.benchmark "Adding Address for Roger RABBIT" do
    address = rabbit.current_address || rabbit.build_current_address
    # NO! address.name = "M. Roger Rabbit"
    address.street_1 = "123 South Street"
    address.town = "Toontown"
    address.postcode = "TT1 1HD"
    address.country = System::Country.find_by(alpha3: "GBR")

    rabbit.by = system_user
    rabbit.save!
  end
end
