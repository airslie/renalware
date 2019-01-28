# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Research::Study, type: :model do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to be_versioned }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to have_db_index(:code) }
    it { is_expected.to have_db_index(:description) }
    it { is_expected.to have_many(:participations) }
    it { is_expected.to have_many(:patients).through(:participations) }
    it { is_expected.to have_many(:investigatorships) }
    it { is_expected.to have_many(:investigators).through(:investigatorships) }
    it { is_expected.to respond_to(:namespace) }
  end
end
