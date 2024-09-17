# frozen_string_literal: true

describe "Managing bookmarks" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new bookmark" do
        params = {
          patients_bookmark: {
            urgent: true,
            notes: "Abc"
          }
        }

        post(patient_bookmarks_path(patient), params: params)
        expect(response).to have_http_status(:redirect)

        bookmark = Renalware::Patients::Bookmark.find_by(patient_id: patient.id)

        expect(bookmark).not_to be_nil
        expect(bookmark.urgent).to be(true)
        expect(bookmark.notes).to eq("Abc")
        follow_redirect!
        expect(response).to be_successful
      end

      it "does not create and implies success if the bookmark already exists" do
        params = {
          patients_bookmark: {
            urgent: true,
            notes: "A note",
            user_id: @current_user.id
          }
        }

        attributes = params[:patients_bookmark].merge!(patient_id: patient.id)
        extant_bookmark = Renalware::Patients::Bookmark.create(attributes)

        post(patient_bookmarks_path(patient), params: params)
        expect(response).to have_http_status(:redirect)

        bookmark = Renalware::Patients::Bookmark.find_by(attributes)

        expect(bookmark).to eq(extant_bookmark)
        follow_redirect!
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    let(:bookmark) do
      create(:patients_bookmark,
             user: Renalware::Patients.cast_user(user),
             patient: patient)
    end

    it "soft deletes the bookmark" do
      delete bookmark_path(bookmark)
      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
    end

    it "does not baulk if the bookmark has already been deleted" do
      bookmark.destroy!
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
      delete bookmark_path(bookmark)
      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
    end
  end

  describe "GET index" do
    let(:bookmark) do
      create(:patients_bookmark,
             user: Renalware::Patients.cast_user(user),
             patient: patient)
    end

    it "lists the user's bookmarks" do
      patients = [
        create(:patient, by: user, given_name: "A"),
        create(:patient, by: user, given_name: "B"),
        create(:patient, by: user, given_name: "C")
      ]

      puser = Renalware::Patients.cast_user(@current_user)
      other_user = create(:patients_user, username: "x")

      bookmarks = [
        create(:patients_bookmark, user: puser, patient: patients[0]),
        create(:patients_bookmark, user: puser, patient: patients[1]),
        create(:patients_bookmark, user: other_user, patient: patients[2])
      ]

      get bookmarks_path

      expect(response).to be_successful
      expect(response.body).to match("Bookmarked Patients")
      expect(response.body).to match(bookmarks[0].patient.to_s)
      expect(response.body).to match(bookmarks[1].patient.to_s)
      expect(response.body).not_to match(bookmarks[2].patient.to_s)
    end
  end

  describe "GET edit" do
    let(:bookmark) do
      create(:patients_bookmark,
             user: Renalware::Patients.cast_user(user),
             patient: patient)
    end

    it do
      get edit_bookmark_path(bookmark)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    let(:bookmark) do
      create(:patients_bookmark,
             user: Renalware::Patients.cast_user(user),
             patient: patient,
             urgent: false,
             notes: "ABC")
    end

    it do
      attributes = { urgent: true, notes: "XYZ" }
      patch bookmark_path(bookmark), params: { patients_bookmark: attributes }

      expect(response).to be_redirect
      expect(bookmark.reload).to have_attributes(attributes)
    end
  end
end
