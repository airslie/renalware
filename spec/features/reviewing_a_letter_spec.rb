require 'rails_helper'

feature 'Reviewing a letter' do
  background do
    create(:letter_description, text: 'Biopsy Letter')
    @letter = create(:letter, :review)
    @patient = @letter.patient

    login_as_clinician

    visit edit_patient_letter_path(patient_id: @patient.to_param, id: @letter.to_param)
  end

  scenario 'a clinician amends a letter in review' do
    select 'Biopsy Letter', from: 'Description'
    fill_in 'Message', with: 'Updated text'

    click_on 'Update'

    expect(current_path).to eq(patient_letters_path(@patient))
    within('.letters tbody tr:first-child') do
      expect(page).to have_content('Biopsy Letter')
    end
  end

  scenario 'a clinician archives a reviewed letter' do
  end
end
