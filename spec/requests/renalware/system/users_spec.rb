describe "Managing Users" do
  let(:user) { create(:user, :unapproved, :clinical, prescriber: false) }

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
    context "with valid attributes" do
      it "updates a record" do
        attributes = {
          approved: true,
          role_ids: user.role_ids,
          consultant: "true",
          hidden: true
        }

        patch admin_user_path(user), params: { user: attributes }

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
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { approved: true, role_ids: [] }
        patch admin_user_path(user), params: { user: attributes }

        expect(response).to be_successful
        expect(response.body).to include("<form")
      end
    end
  end
end
