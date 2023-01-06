# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Reporting::Audit do
    it :aggregate_failures do
      is_expected.to validate_presence_of :name
      is_expected.to validate_presence_of :view_name
    end
  end
end
