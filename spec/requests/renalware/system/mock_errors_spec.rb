# frozen_string_literal: true

describe "Producing a mock error so we can test error reporting" do
  describe "index" do
    it "raises a divide by zero error and thus returns a 500 http error" do
      expect {
        get generate_test_internal_server_error_path
      }.to raise_error(RuntimeError)
    end
  end
end
