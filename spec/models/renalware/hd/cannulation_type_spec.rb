# frozen_string_literal: true

module Renalware::HD
  describe CannulationType do
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of(:name) }
  end
end
