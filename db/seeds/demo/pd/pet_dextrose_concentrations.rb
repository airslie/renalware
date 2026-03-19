module Renalware
  Rails.benchmark "PD PET Dextrose Concentrations" do
    PD::PETDextroseConcentration.create!(name: "Dextrose 1.36%", value: 1.36, position: 1)
    PD::PETDextroseConcentration.create!(name: "Dextrose 2.27%", value: 2.27, position: 2)
    PD::PETDextroseConcentration.create!(name: "Dextrose 3.86%", value: 3.86, position: 3)
    PD::PETDextroseConcentration.create!(name: "Extraneal", value: 7.5, position: 4)
    PD::PETDextroseConcentration.create!(name: "Nutrineal", value: 1.5, position: 5)
  end
end
