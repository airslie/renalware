# frozen_string_literal: true

require "rails_helper"

module Renalware::Accesses
  describe PlanType do
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of(:name) }
  end
end
