# frozen_string_literal: true

module Renalware
  RSpec.describe SessionExpiryWarning do
    subject { described_class.new }

    it "renders a dialog driven by the session controller" do
      dialog = fragment.at_css("dialog[data-session-target='warningDialog']")

      expect(dialog).to be_present
      expect(dialog.text).to include("Your session is about to expire")
      expect(dialog.at_css("[data-session-target='countdown']")).to be_present
    end

    it "lets the user stay signed in, including by pressing Escape" do
      dialog = fragment.at_css("dialog")

      expect(dialog["data-action"]).to include("cancel->session#staySignedIn")
      expect(dialog.at_css("button[data-action='session#staySignedIn']").text)
        .to eq("Stay signed in")
    end

    it "lets the user sign out of every open tab" do
      link = fragment.at_css("a[data-method='delete']")

      expect(link["href"]).to eq("/users/sign_out")
      expect(link["data-action"]).to eq("click->session#sendLogoutMessageToAnyOpenTabs")
      expect(link.text).to eq("Log out")
    end
  end
end
