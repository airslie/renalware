describe Renalware::Virology::Profile do
  it :aggregate_failures do
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to respond_to(:document)
    is_expected.to have_db_index(:document)
    is_expected.to have_db_index(:patient_id)
  end
end
