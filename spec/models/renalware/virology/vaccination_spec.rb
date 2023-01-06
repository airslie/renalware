# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Virology::Vaccination do
    it { is_expected.to be_kind_of(Events::Event) }
  end
end
