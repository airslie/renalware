# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe RegimePolicy, type: :policy do
      subject { described_class }

      let(:admin) { create(:user, :admin) }

      permissions :edit? do
        it "is permitted if the regime is current" do
          regime = Regime.new
          allow(regime).to receive(:current?).and_return(true)
          expect(subject).to permit(admin, regime)
        end

        it "is not permitted if the regime is not current" do
          regime = Regime.new
          allow(regime).to receive(:current?).and_return(false)
          expect(subject).not_to permit(admin, regime)
        end
      end
    end
  end
end
