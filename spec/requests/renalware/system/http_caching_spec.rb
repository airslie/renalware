# frozen_string_literal: true

require "rails_helper"

describe "HTTP Caching" do
  let(:patient) { create(:patient) }

  # Note spec/dummy/app/controllers/applciation_controller
  # must include the cache busting concern for this test to pass
  context "when hitting a page inside the engine" do
    describe "Cache-Control HTTP Header" do
      it "includes 'no-store' so the user cannot navigate back" do
        get patient_clinical_summary_path(patient)

        expect(response.headers["Cache-Control"]).to eq("no-cache, no-store")
      end
    end
  end
end
