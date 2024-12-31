describe "Read internal messages for a user" do
  describe "GET read" do
    it "responds successfully" do
      get messaging_internal_read_receipts_path

      expect(response).to be_successful
      expect(response).to render_template(:read)
    end
  end
end
