# frozen_string_literal: true

require "rails_helper"

describe "Renal Registry Preflight checks" do
  let(:user) { @current_user }

  describe "GET patients" do
    it "renders a list of patients with incomplete data" do
      get patients_renal_registry_preflight_checks_path

      expect(response.body).to include("Renal Registry")
    end
  end

  describe "GET death" do
    it "renders a list of deceased patients with incomplete data" do
      get deaths_renal_registry_preflight_checks_path

      expect(response.body).to include("Renal Registry")
    end
  end

  describe "GET missing_esrf" do
    it "renders a list of patients with missing esrf date" do
      get missing_esrf_renal_registry_preflight_checks_path

      expect(response.body).to include("Renal Registry")
    end
  end
end
