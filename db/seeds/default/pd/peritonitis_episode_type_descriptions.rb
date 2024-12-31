module Renalware
  Rails.benchmark "Adding PD Episode Type Descriptions" do
    file_path = File.join(File.dirname(__FILE__), "peritonitis_episode_type_descriptions.csv")
    CSV.foreach(file_path, headers: true) do |row|
      PD::PeritonitisEpisodeTypeDescription.find_or_create_by!(
        term: row["term"],
        definition: row["definition"]
      )
    end
  end
end
