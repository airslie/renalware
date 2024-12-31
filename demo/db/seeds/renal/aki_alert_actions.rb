module Renalware
  Rails.benchmark "Adding AKI Alert actions" do
    [
      "IP - Review",
      "IP - Telephone advice",
      "IP - Recovering",
      "IP - Recovered -> Clinic",
      "IP - ITU",
      "IP - F+C",
      "IP - EOL",
      "IP - RIP",
      "IP - on Consult List",
      "IP - on Hotlist",
      "IP - EPR input",
      "A+E - Discharged",
      "Orpington",
      "No AKI",
      "AKI 1",
      "OP bloods",
      "OP bloods - Renal",
      "GP - Sent to A+E",
      "GP - Managed in community",
      "GP - EOL",
      "GP - RIP",
      "HD/PD",
      "No f/u needed"
    ].each do |action_name|
      Renal::AKIAlertAction.find_or_create_by!(name: action_name)
    end
  end
end
