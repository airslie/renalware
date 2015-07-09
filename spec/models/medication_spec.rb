require 'rails_helper'
require './spec/support/login_macros'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicatable) }
  it { should belong_to(:treatable) }
  it { should belong_to(:medication_route) }

  it { should validate_presence_of :patient }

  it { should validate_presence_of(:medicatable_id) }
  it { should validate_presence_of(:dose) }
  it { should validate_presence_of(:medication_route_id) }
  it { should validate_presence_of(:frequency) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:provider) }

  describe 'medication validation custom error messages', :type => :feature, :js => true do
    it 'should display custom error messages when a medication fails validation' do
      @patient = create(:patient)
      login_as_clinician
      visit manage_medications_patient_path(@patient)

      click_link 'Add a new medication'
      click_on 'Save Medication'

      expect(page).to have_content("Medication to be administered can't be blank")
      expect(page).to have_content("Medication's dose can't be blank")
      expect(page).to have_content("Medication's route can't be blank")
      expect(page).to have_content("Medication's frequency & duration can't be blank")
      expect(page).to have_content("Medication's prescribed date can't be blank")
    end
  end

  describe 'self.peritonitis' do
    it "should set 'treatable_type' as 'PeritonitisEpisode' for a medication relating to peritonitis" do
      expect(Medication.peritonitis.treatable_type).to eq('PeritonitisEpisode')
    end
  end

  describe 'self.exit_site' do
    it "should set 'treatable_type' as 'ExitSiteInfection' for a medication relating to exit site" do
      expect(Medication.exit_site.treatable_type).to eq('ExitSiteInfection')
    end
  end

end
