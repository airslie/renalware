# frozen_string_literal: true

require "rails_helper"

describe "Viewing a list of reports", js: true do
  it "displays a list of reports" do
    #  = create(:audit, name: "XX", refresh_schedule: "1 0 * * 1-6")
    report = create(
      :view_metadata,
      view_name: "transplant_mdm_patients",
      sub_category: "XYZ",
      title: "Report1",
      category: :report
    )

    login_as_clinical

    visit reporting_reports_path

    expect(page).to have_content("Reports")
    expect(page).to have_content(report.title)
    expect(page).to have_content(report.sub_category)
  end
end
