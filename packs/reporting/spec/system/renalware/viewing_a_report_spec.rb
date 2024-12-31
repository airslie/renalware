describe "Viewing a report", :js do
  it "displays a report" do
    report = create(
      :view_metadata,
      view_name: "transplant_mdm_patients",
      schema_name: "renalware",
      title: "Report1",
      description: "Desc1",
      category: :report
    )

    login_as_clinical

    expect {
      visit reporting.report_path(report)
    }.to change(report.calls, :count).by(1)

    expect(page).to have_content(report.title)
    expect(page).to have_content(report.description)
  end
end
