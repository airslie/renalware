# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Session, type: :model do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it { is_expected.to be_versioned }
      it { is_expected.to have_many(:prescription_administrations) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:dialysate) }
    end
  end
end
