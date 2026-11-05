RSpec.describe "HD session form with multiple submit buttons", :js do
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }

  before { login_as nurse }

  def other_submit_buttons(clicked_label)
    form = find("form.form-with-multiple-submit-buttons")
    form.all("input[type=submit], button[type=submit]", visible: :all).reject do |button|
      [button.value, button.text].include?(clicked_label)
    end
  end

  it "disables the other submit buttons and drops their disable-with when one is clicked" do
    visit new_patient_hd_session_path(patient)

    # Stop the form actually submitting so we can inspect the buttons afterwards
    page.execute_script(<<~JS)
      document.querySelector("form.form-with-multiple-submit-buttons")
        .addEventListener("submit", (event) => event.stopImmediatePropagation() || event.preventDefault(), true)
    JS

    within(".form-with-multiple-submit-buttons .form-actions", match: :first) do
      click_on t("btn.create")
    end

    others = other_submit_buttons(t("btn.create"))
    expect(others).to be_present
    expect(others).to all(be_disabled)
    expect(others.pluck("data-disable-with")).to all(be_nil)
  end
end
