# frozen_string_literal: true

require "rails_helper"

describe "Viewing a report", js: true do
  it "displays a report" do
    report = create(
      :view_metadata,
      view_name: "transplant_mdm_patients",
      title: "Report1",
      description: "Desc1",
      category: :report
    )

    login_as_clinical

    visit reporting_report_path(report)

    expect(page).to have_content(report.title)
    expect(page).to have_content(report.description)
  end
end
