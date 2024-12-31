describe "Producing a mock error so we can test error reporting" do
  describe "index" do
    it "raises a divide by zero error and thus returns a 500 http error" do
      get generate_test_internal_server_error_path

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
