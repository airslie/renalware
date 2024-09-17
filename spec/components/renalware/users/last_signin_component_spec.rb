# frozen_string_literal: true

describe Renalware::Users::LastSigninComponent, type: :component do
  context "when the user has never logged in" do
    it "renders nothing" do
      user = build_stubbed(:user, last_sign_in_at: nil, current_sign_in_at: nil)
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when the user logs in the first time and last_sign_in_at == current_sign_in_at" do
    it "renders nothing" do
      user = build_stubbed(
        :user,
        last_sign_in_at: "2020-10-10 01:01:01",
        current_sign_in_at: "2020-10-10 01:01:01"
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when has previously signed in" do
    it "renders the last signin date" do
      user = build_stubbed(
        :user,
        last_sign_in_at: "2020-09-09 09:09:09",
        current_sign_in_at: "2020-10-10 01:01:01"
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html
      expect(page).to have_content("You last signed in at 09:09 on 09-Sep-2020")
    end
  end
end
