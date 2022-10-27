# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe InvokeCommandJob, type: :job do
    describe "#perform" do
      context "when command succeeds" do
        it "calls a command" do
          expect {
            described_class.perform_now('echo "hello"')
          }.to output("hello\n").to_stdout_from_any_process
        end
      end

      context "when command fails" do
        it "raises a ruby error" do
          expect {
            described_class.perform_now('>&2 echo "error"')
          }.to raise_error(described_class::InvokeCommandJobError,
                           %Q(error\n; Command: >&2 echo "error"))
        end
      end
    end
  end
end
