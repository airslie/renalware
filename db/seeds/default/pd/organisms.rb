module Renalware
  Rails.benchmark "Adding Renal Reg Organisms" do
    file_path = File.join(File.dirname(__FILE__), "rr_organisms.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::OrganismCode.find_or_create_by!(code: row["code"]) do |code|
        code.name = row["name"]
      end
    end
  end
end
