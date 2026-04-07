# frozen_string_literal: true

module Renalware
  RSpec.describe HD::AcuityAssessments::Summary do
    subject(:component) do
      described_class.new(assessments:, current_user:, patient:, pagy:)
    end

    let(:current_user) { build(:user, :clinical) }
    let(:patient) { create(:hd_patient) }
    let(:pagy) do
      Pagy::Offset.new(count: assessments.count, page: 1, limit: 1, request: pagy_request)
    end
    let(:assessments) { create_list(:hd_acuity_assessment, 2, patient:, created_at: created_on) }
    let(:first_page) { [assessments.first] }
    let(:created_by) { assessments.first.created_by.to_s }
    let(:created_on) { "09-Jul-2025" }
    let(:pagy_request) { Struct.new(:base_url, :path, :params).new("", "/", {}) }

    context "when on the patient's Acuity Assessments page" do
      before do
        allow(view_context).to receive(:current_page?)
          .with(patient_hd_acuity_assessments_path(patient))
          .and_return(true)
      end

      it "renders component without heading" do
        expect(fragment.css("a").text).to include("Guide")
        expect(fragment.css("a").text).to include("Add")
        expect(fragment.css("h2").text).to be_empty
      end

      context "when there are no assessments" do
        let(:assessments) { [] }

        it "renders component" do
          expect(fragment.css("a").text).to include("Guide")
          expect(fragment.css("a").text).to include("Add")
        end
      end
    end

    context "when not on the patient's Acuity Assessments page" do
      before do
        allow(view_context).to receive(:current_page?)
          .with(patient_hd_acuity_assessments_path(patient))
          .and_return(false)
      end

      it "renders component" do
        expect(fragment.css("a").text).to include("Guide")
        expect(fragment.css("a").text).to include("Add")
        expect(fragment.css("h2").text).to include("Acuity Assessments")
      end

      context "when there are no assessments" do
        let(:assessments) { [] }

        it "renders component" do
          expect(fragment.text).not_to include("Guide")
          expect(fragment.css("a").text).not_to include("Add")
        end
      end
    end
  end
end
