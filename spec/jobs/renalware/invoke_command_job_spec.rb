# frozen_string_literal: true

module Renalware
  describe InvokeCommandJob do
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
            described_class.perform_now("nonexistingcommand")
          }.to raise_error(Errno::ENOENT, "No such file or directory - nonexistingcommand")

          expect {
            expect {
              described_class.perform_now("(exit 1)")
            }.to output.to_stdout_from_any_process
          }.to raise_error(described_class::InvokeCommandJobError,
                           /Error executing '\(exit 1\)'/)
        end
      end
    end
  end
end
