# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    module Delivery
      describe Event, type: :model do
        it_behaves_like "a Paranoid model"
        it_behaves_like "an Accountable model"
        it { is_expected.to belong_to :drug_type }
        it { is_expected.to have_many :prescriptions }
        it { is_expected.to belong_to :patient }
        it { is_expected.to validate_presence_of :patient }
      end
    end
  end
end
