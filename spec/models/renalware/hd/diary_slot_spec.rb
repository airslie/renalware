# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  describe DiarySlot, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to belong_to(:diary).touch(true) }
    it { is_expected.to belong_to(:patient).touch(true) }
    it { is_expected.to belong_to(:station) }
    it { is_expected.to belong_to(:diurnal_period_code) }
    it { is_expected.to validate_presence_of(:diary) }
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:station) }
    it { is_expected.to validate_presence_of(:day_of_week) }
    it { is_expected.to validate_presence_of(:diurnal_period_code) }
    it { is_expected.to validate_inclusion_of(:day_of_week).in_range(1..7) }
  end
end
