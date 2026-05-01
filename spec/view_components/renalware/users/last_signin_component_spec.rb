describe Renalware::Users::LastSigninComponent, type: :component do
  let(:one_month_ago) { 1.month.ago }
  let(:current_time) { Time.current }
  let(:two_days_ago) { 2.days.ago }
  let(:ten_days_ago) { 10.days.ago }

  let(:success_message) { "You last signed in" }
  let(:failed_message) { "Your account had a failed sign-in attempt" }

  context "when the user has never signed in" do
    it "renders nothing" do
      user = build_stubbed(:user, last_sign_in_at: nil, current_sign_in_at: nil)
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when the user signs in the first time and last time matches current" do
    it "renders nothing" do
      user = build_stubbed(
        :user,
        last_sign_in_at: current_time,
        current_sign_in_at: current_time
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when the user has previously signed in" do
    it "renders the last signin date" do
      user = build_stubbed(
        :user,
        last_sign_in_at: ten_days_ago,
        current_sign_in_at: current_time
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html
      expect(page).to have_text success_message
      expect(page).to have_text "10 days ago"
    end
  end

  context "when the user failed to sign in" do
    context "when no last signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: two_days_ago,
          current_sign_in_at: current_time
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_text failed_message
        expect(page).to have_text "2 days ago"
      end
    end

    context "when last signin is the same as current signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: ten_days_ago,
          last_sign_in_at: current_time,
          current_sign_in_at: current_time
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_text failed_message
        expect(page).to have_text "10 days ago"
      end
    end

    context "when failed signin is more recent than last signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: two_days_ago,
          last_sign_in_at: one_month_ago,
          current_sign_in_at: current_time
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_text failed_message
        expect(page).to have_text "2 days ago"
      end
    end

    context "when failed signin is older than last signin" do
      it "renders the last signin attempt (not the failed signin)" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: one_month_ago,
          last_sign_in_at: two_days_ago,
          current_sign_in_at: current_time
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_text success_message
        expect(page).to have_text "2 days ago"
      end
    end
  end
end
