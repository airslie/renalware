module Renalware
  Rails.benchmark "Creating Admission::RequestReasons" do
    [
      "AKI",
      "For Biopsy",
      "Access",
      "Tx Dysfunction",
      "Crash Lander",
      "Other Medical - please specify",
      "Other Social - please specify"
    ].each do |description|
      Admissions::RequestReason.find_or_create_by!(description: description)
    end
  end
end
