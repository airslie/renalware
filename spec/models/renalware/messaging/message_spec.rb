module Renalware::Messaging
  describe Message do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:subject)
      is_expected.to validate_presence_of(:body)
      is_expected.to validate_presence_of(:author)
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:sent_at)
      is_expected.to have_db_index(:patient_id)
      is_expected.to have_db_index(:author_id)
      is_expected.to have_db_index(:subject)
      is_expected.to have_db_index(:type)
      is_expected.to belong_to(:patient)
      is_expected.to respond_to(:type)
    end
  end
end
