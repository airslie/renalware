describe "Viewing a list of reports" do
  let(:user) { create(:user, :clinical) }

  it "displays a list of reports" do
    report = create(
      :view_metadata,
      view_name: "transplant_mdm_patients",
      sub_category: "XYZ",
      title: "Report1",
      category: :report
    )

    login_as user

    visit reporting.reports_path

    expect(page).to have_content("Reports")
    expect(page).to have_content(report.title)
    expect(page).to have_content(report.sub_category)
  end
end
