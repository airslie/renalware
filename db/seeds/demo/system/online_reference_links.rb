module Renalware
  Rails.benchmark "Adding Online Reference Links " do
    System::OnlineReferenceLink.new(
      url: "https://www.nhs.uk/conditions/kidney-disease/diagnosis/",
      title: "Chronic kidney disease - Diagnosis",
      description: "Find out how chronic kidney disease (CKD) is diagnosed, who should get tested " \
                   "and what the stages of CKD mean."
    ).save_by!(Renalware::User.first)

    System::OnlineReferenceLink.new(
      url: "https://www.nhs.uk/conditions/acute-kidney-injury/",
      title: "Acute kidney injury",
      description: "Acute kidney injury (AKI) is sudden damage to the kidneys that causes them " \
                   "to not work properly. It can range from minor loss of kidney function to " \
                   "complete kidney failure."
    ).save_by!(Renalware::User.first)
  end
end
