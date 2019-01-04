# frozen_string_literal: true

require "rails_helper"

describe "Managing clinical study membership" do
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
  let(:membership) do
    create(
      :research_membership,
      study: study,
      user: user,
      hospital_centre: hospital,
      by: user
    )
  end

  describe "GET index" do
    it "renders a list of study members" do
      get research_study_memberships_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match("Members")
    end
  end

  describe "GET new" do
    it "renders" do
      get new_research_study_membership_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:new, format: :html)
    end
  end

  describe "DELETE JS destroy" do
    it "deletes the member" do
      delete research_study_membership_path(study, membership)

      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(Renalware::Research::Membership.count).to eq(0)
    end
  end

  describe "POST HTTP create" do
    context "with valid inputs" do
      it "add the user to the study" do
        params = { user_id: user.id, hospital_centre_id: hospital.id }

        post(
          research_study_memberships_path(study),
          params: { research_study_membership: params }
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
          research_study_memberships_path(study),
          params: { research_study_membership: params }
        )

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_research_study_membership_path(membership.study, membership)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      it "updates the membership" do
        params = { hospital_centre_id: hospital.id }
        url = research_study_membership_path(membership.study, membership)
        patch url, params: { research_study_membership: params }

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
      end
    end
  end
end
