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
      "PO" => "Per Oral",
      "IV" => "Intravenous",
      "SC" => "Subcutaneous",
      "IM" => "Intramuscular",
      "Other" => "Other (Refer to notes)"
    }

    medication_routes.map do |name, fullname|
      route = create(:medication_route, name: name, full_name: fullname)
      instance_variable_set(:"@#{name.downcase}", route)
    end
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
