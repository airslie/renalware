# frozen_string_literal: true

module Renalware::HD::Scheduling
  describe Diary do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:hospital_unit_id)
      is_expected.to have_many(:slots)
    end
  end
end
