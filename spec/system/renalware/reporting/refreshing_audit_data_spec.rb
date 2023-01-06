# frozen_string_literal: true

require "rails_helper"

describe "Refreshing audit data", js: true do
  it "Manually requesting to refresh audit data" do
    login_as_super_admin
    create(:audit, name: "xx", view_name: "yy")
    visit reporting_audits_path
    ActiveJob::Base.queue_adapter = :test

    within "table.audits" do
      click_on "Refresh Data"
    end

    pending

    expect(Renalware::Reporting::RefreshAuditDataJob).to have_been_enqueued
  end
end
