# frozen_string_literal: true

require "rails_helper"

describe "Managing audits" do
  it "Updating an audit" do
    audit = create(:audit, name: "XX")
    login_as_super_admin
    visit reporting_audits_path
    stub_the_list_of_data_sources

    within "table.audits" do
      click_on t("btn.edit")
    end

    expect(page).to have_current_path(edit_reporting_audit_path(audit))
    display_config = "{test: 1}"
    fill_in t_audit(:name), with: "Changed name"
    fill_in t_audit(:description), with: "Desc"
    select "reporting_test_view2", from: t_audit(:view_name)
    fill_in t_audit(:display_configuration), with: display_config
    fill_in t_audit(:refresh_schedule), with: "5 0 * * *"
    click_on t("btn.save")

    expect(page).to have_current_path(reporting_audits_path)

    audit.reload

    expect(audit.name).to eq("Changed name")
    expect(audit.description).to eq("Desc")
    expect(audit.display_configuration).to eq(display_config)
    expect(audit.refresh_schedule).to eq("5 0 * * *")
  end

  def t_audit(key, scope: "activerecord.attributes.renalware/reporting/audit")
    t(key.to_s, scope: scope)
  end

  def stub_the_list_of_data_sources
    allow(Renalware::Reporting::Audit)
      .to receive(:available_audit_materialized_views)
      .and_return(%w(reporting_test_view1 reporting_test_view2))
  end
end
