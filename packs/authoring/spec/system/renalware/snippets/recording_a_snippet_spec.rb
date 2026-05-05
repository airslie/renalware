RSpec.describe "Recording a snippet", :js do
  let(:clinician) { create(:user, :clinical) }
  let(:title) { "Nephrology Clinic DNA" }
  let(:body) { "This lady did not attend the Nephrology Clinic today" }

  it "A clinician recorded a new snippet" do
    login_as clinician

    visit authoring.snippets_path

    click_on "Create new"
    fill_in "Title", with: "<script>alert('xss')</script>#{title}"
    fill_trix_editor with: body
    click_on "Create"

    expect(page).to have_text("Snippet added")

    expect(page).to have_text("#{title}\t\n#{body}")
  end
end
