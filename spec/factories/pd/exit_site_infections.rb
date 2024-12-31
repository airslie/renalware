FactoryBot.define do
  factory :exit_site_infection, class: "Renalware::PD::ExitSiteInfection" do
    patient
    diagnosis_date { "01/04/2015" }
    treatment { "Having treatment for exit site infection." }
    outcome { "Outcome is satisfactory." }
    notes { "Review in 2 weeks time, observe for temperature." }
  end
end
