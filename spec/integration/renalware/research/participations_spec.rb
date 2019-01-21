# frozen_string_literal: true

require "rails_helper"

describe "Managing clinical study participation", type: :request do
  let(:user) { @current_user }

  def create_study
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones"
    )
  end

  describe "GET index" do
    it "renders a list of study participations" do
      study = create_study

      get research_study_participations_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match("Participants")
    end
  end

  describe "GET new" do
    it "renders" do
      study = create_study

      get new_research_study_participation_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:new, format: :html)
    end
  end

  describe "DELETE JS destroy" do
    it "soft deletes the participation" do
      study = create_study
      patient = create(:patient, by: user, family_name: "ZZ")
      participation = create(:research_participation, study: study, patient: patient)

      expect do
        delete research_study_participation_path(study, participation, format: :js)
      end.to change{ Renalware::Research::Participation.count }.by(-1)

      follow_redirect!
      expect(response).to be_successful
      expect(Renalware::Research::Participation.deleted.count).to eq(1)
      within ".study-participations-table" do
        expect(response.body).not_to include("ZZ")
      end
    end
  end

  describe "POST HTTP create" do
    context "with valid inputs" do
      it "add the participant to the study" do
        study = create_study
        patient = create(:patient, by: user)
        params = { patient_id: patient.id, joined_on: "01-Oct-2017", left_on: "02-Oct-2017" }

        post(
          research_study_participations_path(study),
          params: { participation: params }
        )

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)

        expect(Renalware::Research::Participation.count).to eq(1)
        participant = Renalware::Research::Participation.first
        expect(participant.patient.id).to eq(patient.id)
        expect(I18n.l(participant.joined_on)).to eq("01-Oct-2017")
        expect(I18n.l(participant.left_on)).to eq("02-Oct-2017")
      end
    end

    context "with invalid inputs" do
      it "re-renders the form with validation errors" do
        study = create_study
        params = { patient_id: nil }

        post(
          research_study_participations_path(study),
          params: { participation: params }
        )

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        participant = create(:research_participation)

        get edit_research_study_participation_path(participant.study, participant)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      it "updates the participant" do
        participant = create(:research_participation)

        params = { joined_on: 1.year.ago.to_date }
        url = research_study_participation_path(participant.study, participant)
        patch url, params: { participation: params }

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(participant.reload.joined_on).to eq(params[:joined_on])
      end
    end
  end
end
