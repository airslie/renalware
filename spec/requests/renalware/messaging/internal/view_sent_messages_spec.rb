# frozen_string_literal: true

describe "Internal sent messages for a user" do
  describe "GET sent" do
    it "responds successfully" do
      get messaging_internal_sent_messages_path

      expect(response).to be_successful
    end
  end
end
