module Renalware
  Rails.benchmark "Adding Exit Site Infection for Roger RABBIT" do
    PD::ExitSiteInfection.create!({
                                    patient_id: 1,
                                    diagnosis_date: "2015-06-09",
                                    treatment: "liquid and electrolyte replacement ",
                                    outcome: "Recovered well. Scheduled another training review session.", notes: ""
                                  })
  end

  Rails.benchmark "Adding Peritonitis Episode for Roger RABBIT" do
    PD::PeritonitisEpisode.find_or_create_by!(patient_id: 1) do |episode|
      episode.patient_id = 1
      episode.diagnosis_date = "2015-09-14"
      episode.treatment_start_date = "2015-09-14"
      episode.treatment_end_date = "2015-09-21"
      episode.episode_type_id = 6
      episode.catheter_removed = true
      episode.line_break = false
      episode.exit_site_infection = false
      episode.diarrhoea = false
      episode.abdominal_pain = true
      episode.fluid_description_id = 4
      episode.white_cell_total = 5
      episode.white_cell_neutro = 57
      episode.white_cell_lympho = 37
      episode.white_cell_degen = 3
      episode.white_cell_other = 3
      episode.notes = ""
    end

    PD::InfectionOrganism.find_or_create_by!(organism_code_id: 3) do |org|
      org.organism_code_id = 3
      org.sensitivity = "+++"
      org.infectable_id = 1
      org.infectable_type = "Renalware::PD::PeritonitisEpisode"
    end

    PD::InfectionOrganism.find_or_create_by!(organism_code_id: 4) do |org|
      org.organism_code_id = 4
      org.sensitivity = "unknown"
      org.infectable_id = 1
      org.infectable_type = "Renalware::PD::ExitSiteInfection"
    end
  end
end
