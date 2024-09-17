# frozen_string_literal: true

describe Renalware::Patients::BookmarksComponent, type: :component do
  context "when a user has bookmarks" do
    it "displays the user's bookmarks" do
      user = create(:patients_user)
      patient = create(:patient, by: user)
      create(:patients_bookmark, user: user, patient: patient)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Bookmarked Patients")
      expect(page).to have_content(patient.to_s)
    end
  end

  context "when a user has no bookmarks" do
    it "displays a no bookmarks message" do
      user = build_stubbed(:patients_user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Bookmarked Patients")
      expect(page).to have_content("There are no patients bookmarked")
    end
  end
end
