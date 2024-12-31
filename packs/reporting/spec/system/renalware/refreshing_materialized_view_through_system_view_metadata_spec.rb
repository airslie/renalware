describe "Refreshing materialized view" do
  let(:user) { create(:user, :clinical) }

  let(:view_metadata) do
    create(
      :view_metadata,
      title: "Title",
      category: :report,
      materialized: true,
      view_name: "yy"
    )
  end

  before do
    view_metadata
    ActiveJob::Base.queue_adapter = :test
  end

  it "manually requesting to refresh the materialized view" do
    login_as user

    visit reporting.reports_path

    within "table" do
      expect(page).to have_content "Title"
      click_button "Refresh Data"
    end

    expect(Renalware::System::RefreshMaterializedViewWithMetadataJob).to have_been_enqueued
    expect(page).to have_content "Materialized View will be refreshed in the " \
                                 "background"

    within "table" do
      expect(page).to have_content I18n.l(Time.zone.today) # the refreshed date
    end
  end
end
