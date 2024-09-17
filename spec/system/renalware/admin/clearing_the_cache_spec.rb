# frozen_string_literal: true

describe "Clearing the Rails cache" do
  it "A super admin clears the Redis cache" do
    login_as_super_admin
    visit admin_dashboard_path

    within ".side-nav--admin" do
      click_on "Cache"
    end

    expect(page).to have_current_path(admin_cache_path)

    allow(Rails.cache).to receive(:clear)

    click_on "Clear the Application Cache"

    expect(Rails.cache).to have_received(:clear)
  end

  it "A super admin clears the PDF Letter cache" do
    login_as_super_admin

    visit admin_cache_path

    allow(Renalware::Letters::PdfLetterCache).to receive(:clear)

    click_on "Clear the PDF Letter Cache"

    expect(Renalware::Letters::PdfLetterCache).to have_received(:clear)
  end
end
