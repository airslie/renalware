RSpec.describe "Listing snippets", :js do
  let(:clinician) { create(:user, :clinical) }
  let(:snippet_user) { Renalware::Authoring.cast_user(clinician) }
  let(:snippet1) { create(:snippet, author: snippet_user) }
  let(:snippet2) { create(:snippet) }
  let(:snippets) { [snippet1, snippet2] }

  before { login_as clinician }

  context "when viewing the snippets page" do
    before { snippets }

    it "displays their own snippets" do
      visit authoring.snippets_path

      expect(page).to have_text("#{snippet1.title}\t\n#{snippet1.body}")
      expect(page).to have_no_text("#{snippet2.title}\t\n#{snippet2.body}")
    end
  end

  context "when clicking the 'Everyone's' tab" do
    before { snippets }

    it "displays all snippets" do
      visit authoring.snippets_path
      click_on "Everyone's"

      expect(page).to have_text("#{snippet1.title}\t\n#{snippet1.body}")
      expect(page).to have_text("#{snippet2.title}\t\n#{snippet2.body}")
    end
  end

  context "when there are multiple pages of snippets" do
    let!(:snippets) { create_list(:snippet, 4, author: snippet_user) }

    before do
      stub_const("Renalware::Authoring::SnippetsController::LIMIT", 2)
      visit authoring.snippets_path
    end

    it "allows navigating to the next page" do
      expect(page).to have_text("#{snippets.first.title}\t\n#{snippets.first.body}")
      expect(page).to have_text("#{snippets.second.title}\t\n#{snippets.second.body}")
      expect(page).to have_no_text("#{snippets.third.title}\t\n#{snippets.third.body}")

      click_on ">"

      expect(page).to have_text("#{snippets.last.title}\t\n#{snippets.last.body}")
      expect(page).to have_link("Edit")
    end
  end
end
