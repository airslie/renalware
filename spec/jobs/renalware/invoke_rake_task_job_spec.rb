# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe InvokeRakeTaskJob, type: :job do
    describe "#perform" do
      it "calls a rake task" do
        expect { described_class.perform_now("db:version") }.to output(/Current version/).to_stdout
      end
    end
  end
end
