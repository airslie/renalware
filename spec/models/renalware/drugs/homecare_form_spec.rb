# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Drugs
    describe HomecareForm, type: :model do
      it { is_expected.to validate_presence_of :form_name }
      it { is_expected.to validate_presence_of :form_version }
      it { is_expected.to validate_presence_of :prescription_durations }
      it { is_expected.to validate_presence_of :prescription_duration_unit }
    end
  end
end
