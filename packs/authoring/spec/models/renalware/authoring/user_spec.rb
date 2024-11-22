# frozen_string_literal: true

module Renalware
  describe Authoring::User do
    describe "validation" do
      it { is_expected.to have_many(:snippets) }
    end
  end
end
