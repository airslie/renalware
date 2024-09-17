# frozen_string_literal: true

describe "View internal messages sent by the current" do
  describe "GET index" do
    it "responds successfully" do
      get messaging_internal_inbox_path

      expect(response).to be_successful
    end
  end
end
