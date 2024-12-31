describe "Managing clinical study investigatorships" do
  let(:user) { @current_user }
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
      by: user,
      started_on: "01-01-2018"
    )
  end

  describe "GET index" do
    it "renders a list of study investigators" do
      get research.study_investigatorships_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match("Investigators")
    end
  end

  describe "GET new" do
    it "renders" do
      get research.new_study_investigatorship_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:new, format: :html)
    end
  end

  describe "DELETE JS destroy" do
    it "deletes the investigatorship" do
      delete research.study_investigatorship_path(study, investigatorship)

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
        params = { user_id: user.id, started_on: "2018-01-01", manager: true }

        post(
          research.study_investigatorships_path(study),
          params: { investigatorship: params }
        )

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)
        investigatorship = study.reload.investigatorships.first
        expect(investigatorship.manager).to be(true)
        expect(investigatorship.user).to eq(user)
      end
    end

    context "with invalid inputs" do
      it "re-renders the form with validation errors" do
        params = { user_id: nil, started_on: "2018-01-01" }

        post(
          research.study_investigatorships_path(study),
          params: { investigatorship: params }
        )

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get research.edit_study_investigatorship_path(investigatorship.study, investigatorship)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      it "updates the investigatorship" do
        params = { started_on: "2018-01-03" }
        url = research.study_investigatorship_path(investigatorship.study, investigatorship)
        patch url, params: { investigatorship: params }

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(investigatorship.reload.started_on).to eq(Date.parse("2018-01-03"))
      end
    end
  end
end
