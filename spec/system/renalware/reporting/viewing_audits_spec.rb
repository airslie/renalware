# frozen_string_literal: true

require "rails_helper"

describe "Viewing audits", js: true do
  include AjaxHelpers

  it "viewing a list of audits" do
    audit = create(:audit, name: "XX", refresh_schedule: "1 0 * * 1-6")
    login_as_clinical

    visit reporting_audits_path

    expect(page).to have_content(audit.name)
    expect(page).to have_content("At 0:01 AM, Monday through Saturday")
  end

  it "viewing an audit" do
    view_name = create_an_example_materialized_view
    audit = create_an_audit_configured_to_use_view_called(view_name)

    login_as_clinical

    visit reporting_audit_path(audit)

    expect(page).to have_content(audit.name)
    expect(page).to have_content(audit.description)

    wait_for_datatables_to_fetch_json_and_build_table

    expect(page).to have_content("Col 1")
    expect(page).to have_content("aaa")
    expect(page).to have_content("Col 2")
    expect(page).to have_content("bbb")
  end

  # Create a temp materialized view and refresh its data
  def create_an_example_materialized_view
    view_name = "reporting_#{Time.zone.now.to_i}"
    ActiveRecord::Base.connection.execute(
      "CREATE MATERIALIZED VIEW #{view_name} AS " \
      "SELECT 'aaa'::text as col1, 'bbb'::text as col2 WITH DATA;"
    )
    view_name
  end

  def create_an_audit_configured_to_use_view_called(view_name)
    create(:audit,
           name: "Test",
           description: "A short description",
           view_name: view_name,
           display_configuration: '{
             "columnDefs": [
               { "title": "Col 1", "width": "100", "data": "col1" },
               { "title": "Col 2", "width": "100", "data": "col2" }
               ]}')
  end

  def wait_for_datatables_to_fetch_json_and_build_table
    wait_for_ajax
  end
end
