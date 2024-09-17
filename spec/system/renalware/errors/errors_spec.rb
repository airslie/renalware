# frozen_string_literal: true

module Renalware
  describe "Errors" do
    before do
      method = Rails.application.method(:env_config)
      allow(Rails.application).to receive(:env_config).with(no_args) do
        method.call.merge(
          "action_dispatch.show_exceptions" => true,
          "action_dispatch.show_detailed_exceptions" => false,
          "consider_all_requests_local" => false
        )
      end
    end

    describe "accessing a non-existent page or resource" do
      it "displays the 404 page" do
        login_as_super_admin

        visit admin_user_path(id: 99999999999)

        expect(page.status_code).to eq(404)
        expect(page).to have_content("Not Found")
      end
    end

    describe "when the an unhandled internal server error" do
      it "displays the 500 page" do
        login_as_clinical

        visit generate_test_internal_server_error_path

        expect(page.status_code).to eq(500)
        expect(page).to have_content("Internal Server Error")
      end
    end
  end
end
