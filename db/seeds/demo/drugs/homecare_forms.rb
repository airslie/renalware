module Renalware
  Rails.benchmark "Register homecare suppliers for delivery" do
    Drugs::HomecareForm.create!(
      drug_type: Drugs::Type.find_by(code: "esa"),
      supplier: Drugs::Supplier.find_by(name: "Generic"),
      form_name: "generic",
      form_version: "1",
      prescription_durations: [3, 6, 9],
      prescription_duration_default: 6,
      prescription_duration_unit: "month"
    )
    Drugs::HomecareForm.create!(
      drug_type: Drugs::Type.find_by(code: "immunosuppressant"),
      supplier: Drugs::Supplier.find_by(name: "Generic"),
      form_name: "generic",
      form_version: "2",
      prescription_durations: [4, 8, 12],
      prescription_duration_default: 8,
      prescription_duration_unit: "week"
    )
  end
end
