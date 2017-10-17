require "rails_helper"

module Renalware
  module HD
    RSpec.describe Profile, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:prescriber) }
      it { is_expected.to respond_to(:active) }
      it { is_expected.to respond_to(:deactivated_at) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:dialysate) }
      it { is_expected.to belong_to(:schedule_definition) }
    end
  end
end
