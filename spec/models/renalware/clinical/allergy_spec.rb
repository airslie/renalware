# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinical::Allergy do
  it_behaves_like "a Paranoid model"
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to validate_presence_of :description
    is_expected.to validate_presence_of :recorded_at
    is_expected.to belong_to(:patient).touch(true)
  end
end
