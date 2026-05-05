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
        patient:,
        difficulty:,
        created_at: Time.zone.parse(date),
        by: user
      )
    end

    component = described_class.new(current_user: user, patient:)
    render_inline(component)
    expect(page).to have_text("Ease of Needling (MAGIC)")
    expect(page).to have_text("01-Jun-2022")
    expect(page).to have_text("01-May-2022")
    expect(page).to have_text("31-Mar-2022")
    expect(page).to have_no_text("28-Feb-2022")
    expect(page).to have_text("Moderate")
    expect(page).to have_text("Easy")
    expect(page).to have_no_text("Hard")
  end
end
