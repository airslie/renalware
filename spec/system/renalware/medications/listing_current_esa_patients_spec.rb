describe "/medications/esa_prescriptions" do
  let(:user) { create(:user, :clinical) }
  let(:patient) { create(:pd_patient, by: user) }

  let(:esa_drug) { create(:drug, name: "ESA Pill") }
  let(:esa_drug_type) { create(:drug_type, :esa) }

  let(:antibiotic_drug) { create(:drug, name: "Antibiotic Pill") }
  let(:antibiotic_drug_type) { create(:drug_type, :antibiotic) }

  let(:esa_prescription) { create(:prescription, drug: esa_drug, patient: patient) }
  let(:antibiotic_prescription) { create(:prescription, drug: antibiotic_drug, patient: patient) }

  before do
    esa_prescription && antibiotic_prescription

    esa_drug.drug_types << esa_drug_type
    antibiotic_drug.drug_types << antibiotic_drug_type

    login_as user
  end

  it "allows to create, edit and terminate a drug" do
    visit medications_esa_prescriptions_path

    expect(page).to have_css("tbody tr", count: 1)

    within "tbody tr" do
      expect(page).to have_content "ESA Pill"
    end
  end
end
