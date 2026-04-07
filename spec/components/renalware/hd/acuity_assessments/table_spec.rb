# frozen_string_literal: true

module Renalware
  RSpec.describe HD::AcuityAssessments::Table do
    subject { described_class.new(assessments: first_page, pagy:, current_user:) }

    let(:current_user) { build(:user, :clinical) }
    let(:pagy) do
      Pagy::Offset.new(count: assessments.count, page: 1, limit: 1, request: pagy_request)
    end
    let(:assessments) { create_list(:hd_acuity_assessment, 2, created_at: created_on) }
    let(:first_page) { [assessments.first] }
    let(:created_by) { assessments.first.created_by.to_s }
    let(:created_on) { "09-Jul-2025" }
    let(:pagy_request) { Struct.new(:base_url, :path, :params).new("", "/", {}) }

    it "renders component" do
      expect(fragment.css("tr").text).to include("RatioDateAssessor")
      expect(fragment.css("tr").text).to include("1:4#{created_on}#{created_by}")
      expect(fragment.css("div.bg-green-300").text).to eq("1:4")
      expect(fragment.text).to include("<12>")
    end

    context "when there is only one page of assessments" do
      let(:assessments) { create_list(:hd_acuity_assessment, 1, created_at: created_on) }

      it "renders component" do
        expect(fragment.text).to include("1:4#{created_on}#{created_by}")
        expect(fragment.text).not_to include("<1>")
      end
    end
  end
end
