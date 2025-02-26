describe "Managing Users" do
  let(:user) { create(:user, :unapproved, :clinical, prescriber: false) }
  let(:clinical_role) { create(:role, :clinical) }

  describe "GET index" do
    it "responds with a list" do
      get admin_users_path

      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_admin_user_path(user)

      expect(response).to be_successful
    end

    context "when editing itself" do
      it "redirects to the list" do
        get edit_admin_user_path(@current_user)

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PATCH update" do
    context "when the user is not yet approved" do
      let(:user) { create(:user, :unapproved) }

      it "approves the user when Approve btn (has name=approve) is clicked" do
        expect(user.approved?).to be(false)

        attributes = {
          role_ids: [clinical_role.id],
          consultant: "true",
          hidden: true
        }

        patch admin_user_path(user), params: { approve: "title of approve btn", user: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::User).to exist(
          id: user.id,
          approved: true,
          consultant: true,
          hidden: true
        )

        follow_redirect!

        expect(response).to be_successful
      end

      it "saves without approving (or validating roles) if 'Save (approve later)' is clicked" do
        expect(user.approved?).to be(false)

        attributes = { role_ids: [], consultant: "true", notes: "some notes" }

        patch admin_user_path(user), params: { user: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::User).to exist(
          id: user.id,
          approved: false,
          consultant: true,
          notes: "some notes"
        )

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "when the user is already approved" do
      let(:user) { create(:user, :clinical, approved: true) }

      context "with valid attributes" do
        it "updates a record" do
          attributes = {
            role_ids: user.role_ids,
            consultant: "true",
            hidden: true
          }

          patch admin_user_path(user), params: { approve: "title of approve btn", user: attributes }

          expect(response).to have_http_status(:redirect)
          expect(Renalware::User).to exist(
            id: user.id,
            consultant: true,
            hidden: true,
            approved: true
          )

          follow_redirect!

          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        it "complains if no roles specified, and redisplays edit form" do
          attributes = { role_ids: [] }
          patch admin_user_path(user), params: { user: attributes }

          expect(response).to be_successful
          expect(response.body).to include("<form")
        end
      end
    end
  end
end
