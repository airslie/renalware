# frozen_string_literal: true

module Renalware::Accesses
  describe Type do
    it { is_expected.to validate_presence_of(:name) }
  end
end
