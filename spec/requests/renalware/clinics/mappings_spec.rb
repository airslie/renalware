describe "Clinic mappings" do
  let(:clinic) { create(:clinic) }
  let!(:mapping) { Renalware::Clinics::Mapping.create!(name_in_feed: "Nephrology - Building B", clinic:) }

  before { login_as_super_admin }

  it "lists mapped and unmapped feed names and renders the forms" do
    Renalware::Clinics::Mapping.create!(name_in_feed: "Unknown clinic")

    get clinic_mappings_path
    expect(response).to be_successful
    expect(response.body).to include(mapping.name_in_feed, clinic.name, "Unmapped")

    get new_clinic_mapping_path
    expect(response).to be_successful
    expect(response.body).to include("Clinic name in feed", "Renalware clinic")

    get edit_clinic_mapping_path(mapping)
    expect(response).to be_successful
    expect(response.body).to include(mapping.name_in_feed)
  end

  it "creates a mapping with a default clinic" do
    post clinic_mappings_path, params: {
      mapping: {
        name_in_feed: "Nephrology - Building C", clinic_id: clinic.id, default_clinic: "1"
      }
    }

    expect(response).to redirect_to(clinic_mappings_path)
    expect(Renalware::Clinics::Mapping.find_by!(name_in_feed: "Nephrology - Building C"))
      .to have_attributes(clinic_id: clinic.id, default_clinic: true)
  end

  it "updates a mapping and clears its clinic" do
    patch clinic_mapping_path(mapping), params: {
      mapping: { name_in_feed: "Renamed clinic", clinic_id: "" }
    }

    expect(response).to redirect_to(clinic_mappings_path)
    expect(mapping.reload).to have_attributes(name_in_feed: "Renamed clinic", clinic_id: nil)
  end

  it "deletes a mapping without deleting its clinic" do
    expect {
      delete clinic_mapping_path(mapping)
    }.to change(Renalware::Clinics::Mapping, :count).by(-1)
    expect(response).to redirect_to(clinic_mappings_path)
    expect(Renalware::Clinics::Clinic.exists?(clinic.id)).to be(true)
  end

  it "renders validation errors for duplicate names regardless of case" do
    expect {
      post clinic_mappings_path, params: { mapping: { name_in_feed: mapping.name_in_feed.upcase } }
    }.not_to change(Renalware::Clinics::Mapping, :count)
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("has already been taken")
  end

  it "renders validation errors for blank names on update" do
    patch clinic_mapping_path(mapping), params: { mapping: { name_in_feed: "" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(mapping.reload.name_in_feed).to eq("Nephrology - Building B")
  end

  it "prevents a second default mapping" do
    mapping.update!(default_clinic: true)
    post clinic_mappings_path, params: {
      mapping: { name_in_feed: "Another clinic", clinic_id: clinic.id, default_clinic: "1" }
    }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("has already been taken")
    expect(Renalware::Clinics::Mapping.where(default_clinic: true).count).to eq(1)
  end

  %i(admin clinical read_only devops).each do |role|
    it "denies every management endpoint for a #{role} user" do
      login_as(create(:user, role:))
      original_attributes = mapping.attributes

      expect_management_requests_to_be_denied

      expect(mapping.reload.attributes).to eq(original_attributes)
      expect(Renalware::Clinics::Mapping.count).to eq(1)
    end
  end

  def expect_management_requests_to_be_denied
    requests = [
      [:get, clinic_mappings_path],
      [:get, new_clinic_mapping_path],
      [:get, edit_clinic_mapping_path(mapping)],
      [:post, clinic_mappings_path],
      [:patch, clinic_mapping_path(mapping)],
      [:delete, clinic_mapping_path(mapping)]
    ]

    requests.each do |method, path|
      public_send(method, path, params: { mapping: { name_in_feed: "Unauthorised" } })
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
