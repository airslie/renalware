describe "Deleting clinic mappings", :js do
  let(:clinic) { create(:clinic) }
  let!(:default_mapping) do
    create(:clinics_mapping, name_in_feed: "Default Clinic", clinic:, default_clinic: true)
  end

  before { login_as_super_admin }

  it "keeps an ordinary mapping when cancelled and deletes it when confirmed" do
    mapping = create(:clinics_mapping, name_in_feed: "Nephrology - Building B", clinic:)
    confirmation = "Delete this clinic mapping? " \
                   "Future messages may recreate it using the default clinic."
    visit clinic_mappings_path

    dismiss_confirm(confirmation) { delete_link(mapping).click }
    expect(page).to have_css("#clinics_mapping_#{mapping.id}")
    expect(Renalware::Clinics::Mapping.exists?(mapping.id)).to be(true)

    accept_confirm(confirmation) { delete_link(mapping).click }
    expect(page).to have_no_css("#clinics_mapping_#{mapping.id}")
    expect(Renalware::Clinics::Mapping.exists?(mapping.id)).to be(false)
    expect(Renalware::Clinics::Mapping.default_clinic_id).to eq(clinic.id)
  end

  it "warns that deleting the default mapping also removes the fallback clinic" do
    confirmation = "Delete this default clinic mapping? " \
                   "This also removes the fallback clinic for previously unseen feed names. " \
                   "Future messages may recreate this mapping without a clinic assigned."
    visit clinic_mappings_path

    dismiss_confirm(confirmation) { delete_link(default_mapping).click }
    expect(Renalware::Clinics::Mapping.default_clinic_id).to eq(clinic.id)

    accept_confirm(confirmation) { delete_link(default_mapping).click }
    expect(page).to have_no_css("#clinics_mapping_#{default_mapping.id}")
    expect(Renalware::Clinics::Mapping.exists?(default_mapping.id)).to be(false)
    expect(Renalware::Clinics::Mapping.default_clinic_id).to be_nil
    expect(Renalware::Clinics::Clinic.exists?(clinic.id)).to be(true)
  end

  def delete_link(mapping)
    find("#clinics_mapping_#{mapping.id}").find_link("Delete")
  end
end
