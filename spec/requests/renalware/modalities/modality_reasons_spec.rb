# frozen_string_literal: true

require "rails_helper"

describe "Listing Modality Reasons" do
  describe "GET index" do
    it "responds with a list" do
      create(:pd_to_haemodialysis, description: "::modality name::")

      get modalities_reasons_path

      expect(response).to be_successful
      expect(response.body).to match("::modality name::")
    end
  end
end
