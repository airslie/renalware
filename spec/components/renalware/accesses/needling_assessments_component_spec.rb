# frozen_string_literal: true

describe Renalware::Accesses::NeedlingAssessmentsComponent, type: :component do
  let(:user) { create(:user) }
  let(:patient) { create(:accesses_patient, by: user) }

  it "displays the last 3 needling assessments" do
    {
      "01-May-2022" => :easy,
      "01-Jun-2022" => :moderate,
      "28-Feb-2022" => :hard,
      "31-Mar-2022" => :moderate
    }.each do |date, difficulty|
      create(
        :access_needling_assessment,
        patient: patient,
        difficulty: difficulty,
        created_at: Time.zone.parse(date),
        by: user
      )
    end

    component = described_class.new(current_user: user, patient: patient)
    render_inline(component)
    expect(page).to have_content("Ease of Needling (MAGIC)")
    expect(page).to have_content("01-Jun-2022")
    expect(page).to have_content("01-May-2022")
    expect(page).to have_content("31-Mar-2022")
    expect(page).to have_no_content("28-Feb-2022")
    expect(page).to have_content("Moderate")
    expect(page).to have_content("Easy")
    expect(page).to have_no_content("Hard")
  end
end
