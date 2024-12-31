module DrugsSpecHelper
  def load_drugs(*names)
    names.each do |name|
      drug = create(:drug, name: name)
      instance_variable_set(:"@#{name.downcase}", drug)
    end
  end

  # { 'Amoxicillin' => ['Antibiotic', 'Peritonitis'], 'Penicillin' => ['Foo', ...] }
  def load_drugs_by_type(drugs_by_type)
    drugs_by_type.each do |drug_name, drug_type_names|
      drug = assign_drug(drug_name)
      drug_type_names.each { |name| assign_drug_type(drug, name) }
    end
  end

  def load_med_routes
    medication_routes = {
      "PO" => "Oral",
      "IV" => "Intravenous",
      "SC" => "Subcutaneous",
      "IM" => "Intramuscular",
      "Other" => "Other (Refer to notes)"
    }

    medication_routes.map do |code, name|
      route = create(:medication_route, code: code, name: name)
      instance_variable_set(:"@#{code.downcase}", route)
    end
  end

  def refresh_prescribable_drugs_materialized_view
    Scenic.database.refresh_materialized_view(
      "drug_prescribable_drugs",
      concurrently: false,
      cascade: false
    )
  end

  private

  def assign_drug(name)
    drug = create(:drug, name: name)
    instance_variable_set(:"@#{name.downcase}", drug)
  end

  def assign_drug_type(drug, name)
    drug_type = Renalware::Drugs::Type.find_by(code: name.downcase)

    if drug_type.blank?
      drug_type = create(:drug_type, code: name.downcase, name: name)
      instance_variable_set(:"@#{name.downcase}", drug_type)
    end

    drug.drug_types << drug_type
  end
end
