RSpec.describe "Handling failed remote requests", :js do
  before { login_as create(:user, role: "clinical") }

  it "alerts the user when a remote request fails with a 500" do
    visit root_path

    message = accept_alert do
      page.execute_script(<<~JS)
        document.dispatchEvent(new CustomEvent("ajax:error", {
          detail: [null, null, { status: 500, statusText: "Internal Server Error" }]
        }))
      JS
    end

    expect(message).to eq(
      "Your request has unexpectedly failed (Internal Server Error). Please try again."
    )
  end
end
