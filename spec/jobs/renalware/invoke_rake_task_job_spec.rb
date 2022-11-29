# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe InvokeRakeTaskJob, type: :job do
    describe "#perform" do
      require "rake"
      include Rake::DSL

      after do
        Rake::Task.clear
      end

      it "calls a rake task" do
        task :test do
          puts "test"
        end

        expect {
          described_class.perform_now("test")
        }.to output(/test/).to_stdout
      end
    end
  end
end
