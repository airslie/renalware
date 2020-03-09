# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    module Delivery
      describe EventPrescription, type: :model do
        it { is_expected.to belong_to :event }
        it { is_expected.to belong_to :prescription }
        it { is_expected.to validate_presence_of :event }
        it { is_expected.to validate_presence_of :prescription }
        it { is_expected.to have_db_index([:event_id, :prescription_id]).unique(true) }
      end
    end
  end
end
