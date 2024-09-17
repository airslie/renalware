# frozen_string_literal: true

describe "PD Dashboard" do
  it "displays the top 5 CAPD and links through to display all of them" do
    user = login_as_clinical

    patient = create(:pd_patient, by: user)
    bag_type = create(:bag_type)

    6.times do
      build(:capd_regime, patient: patient).tap do |regime|
        regime.bags << build(:pd_regime_bag, regime: regime, bag_type: bag_type)
        regime.save!
      end
    end

    visit patient_pd_dashboard_path(patient)

    within "article.capd-regimes header" do
      expect(page).to have_content("CAPD Regimes")
      expect(page).to have_content("(5 of 6)")
      click_on "View All"
    end
    # Visit the page to view all CAPD regimes (regimes#index)
    expect(page).to have_current_path(patient_pd_capd_regimes_path(patient))
    # refresh page so we can change the per_page param
    visit patient_pd_capd_regimes_path(patient)
    expect(page).to have_content("PD Summary") # breadcrumb
    expect(page).to have_content("CAPD Regimes")
    # Display 5 - the 6th is on another page'
    expect(page).to have_css("table.capd-regimes tbody tr", count: 6)
  end

  it "displays the top 5 APD and links through to display all of them" do
    user = login_as_clinical

    patient = create(:pd_patient, by: user)
    bag_type = create(:bag_type)

    6.times do
      build(:apd_regime, patient: patient).tap do |regime|
        regime.bags << build(:pd_regime_bag, regime: regime, bag_type: bag_type)
        regime.save!
      end
    end

    visit patient_pd_dashboard_path(patient)

    within "article.apd-regimes header" do
      expect(page).to have_content("APD Regimes")
      expect(page).to have_content("(5 of 6)")
      click_on "View All"
    end
    # Visit the page to view all APD regimes (regimes#index)
    expect(page).to have_current_path(patient_pd_apd_regimes_path(patient))
    expect(page).to have_content("APD Regimes")
    expect(page).to have_css("table.apd-regimes tbody tr", count: 6)
  end
end
