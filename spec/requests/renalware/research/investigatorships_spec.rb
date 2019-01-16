# frozen_string_literal: true

require "rails_helper"

describe "Managing clinical study investigatorships" do
  let(:user) { @current_user }
  let(:hospital) { create(:hospital_centre) }
  let(:study) do
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones",
      by: user
    )
  end
  let(:investigatorship) do
    create(
      :research_investigatorship,
      study: study,
      user: user,
      hospital_centre: hospital,
      by: user
    )
  end

  describe "GET index" do
    it "renders a list of study investigators" do
      get research_study_investigatorships_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match("Investigators")
    end
  end

  describe "GET new" do
    it "renders" do
      get new_research_study_investigatorship_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:new, format: :html)
    end
  end

  describe "DELETE JS destroy" do
    it "deletes the investigatorship" do
      delete research_study_investigatorship_path(study, investigatorship)

      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(Renalware::Research::Investigatorship.count).to eq(0)
    end
  end

  describe "POST HTTP create" do
    context "with valid inputs" do
      it "add the user to the study" do
        params = { user_id: user.id, hospital_centre_id: hospital.id }

        post(
          research_study_investigatorships_path(study),
          params: { research_study_investigatorship: params }
        )

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)
      end
    end

    context "with invalid inputs" do
      it "re-renders the form with validation errors" do
        params = { user_id: nil, hospital_centre_id: nil }

        post(
          research_study_investigatorships_path(study),
          params: { research_study_investigatorship: params }
        )

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_research_study_investigatorship_path(investigatorship.study, investigatorship)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      it "updates the investigatorship" do
        params = { hospital_centre_id: hospital.id }
        url = research_study_investigatorship_path(investigatorship.study, investigatorship)
        patch url, params: { research_study_investigatorship: params }

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
      end
    end
  end
end
