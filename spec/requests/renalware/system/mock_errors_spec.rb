describe "Producing a mock error so we can test error reporting" do
  describe "index" do
    before do
      method = Rails.application.method(:env_config)
      allow(Rails.application).to receive(:env_config).with(no_args) do
        method.call.merge(
          "action_dispatch.show_exceptions" => true
        )
      end
    end

    it "raises a divide by zero error and thus returns a 500 http error" do
      get generate_test_internal_server_error_path

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
