FactoryBot.define do
  factory :peritonitis_episode, class: "Renalware::PD::PeritonitisEpisode" do
    patient
    diagnosis_date { "30/01/2015" }
    treatment_start_date { "1/02/2015" }
    treatment_end_date { "28/02/2015" }
    catheter_removed { true }
    line_break { false }
    exit_site_infection { true }
    diarrhoea { false }
    abdominal_pain { false }
    fluid_description
    white_cell_total { 2000 }
    white_cell_neutro { 25 }
    white_cell_lympho { 25 }
    white_cell_degen { 20 }
    white_cell_other { 30 }
    notes { "Needs review in 6 weeks" }
  end
end
