module Renalware
  Rails.benchmark "Adding Patient Group Directions (PGD)" do
    upserts = [
      {
        name: "Enoxaparin 20mg",
        code: "pgd1"
      },
      {
        name: "Enoxaparin 40mg",
        code: "pgd2"
      },
      {
        name: "Enoxaparin 60mg",
        code: "pgd3"
      },
      {
        name: "Normal saline intravenous fluid resuscitation",
        code: "pgd4"
      },
      {
        name: "Gelofusin intravenous fluid resuscitation",
        code: "pgd5"
      },
      {
        name: "Naseptin",
        code: "pgd6"
      },
      {
        name: "Mupurocin / Octenisan decolonisation",
        code: "pgd7"
      },
      {
        name: "Biopatch protective disc",
        code: "pgd8"
      }
    ]
    Renalware::Drugs::PatientGroupDirection.upsert_all(upserts, unique_by: :code)
  end
end
