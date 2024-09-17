# frozen_string_literal: true

describe "View a list of home delivery prescriptions filtered by delivery dates" do
  let(:esa_drug_type) { create(:drug_type, :esa) }
  let(:esa_drug) do
    create(:drug, name: "esa drug").tap { |drug| drug.drug_types << esa_drug_type }
  end
  let(:immuno_drug_type) { create(:drug_type, :immunosuppressant) }
  let(:immuno_drug) do
    create(:drug, name: "immuno drug").tap { |drug| drug.drug_types << immuno_drug_type }
  end

  def create_home_delivery_prescription(
    patient,
    user,
    drug,
    last_delivery_date:,
    next_delivery_date:
  )
    create(
      :prescription,
      drug: drug,
      by: user,
      dose_amount: "100",
      dose_unit: "milligram",
      patient: patient,
      medication_route: create(:medication_route, :po),
      prescribed_on: "2020-01-01",
      provider: :home_delivery,
      last_delivery_date: last_delivery_date,
      next_delivery_date: next_delivery_date
    )
  end

  it "displays matching esa prescriptions" do
    # For criteria logic tests so tests for the query object used on the controller
    travel_to Date.parse("01-12-2020") do
      now = Time.zone.now
      user = login_as_admin
      patient = create(:patient)
      prescription = create_home_delivery_prescription(
        patient,
        user,
        esa_drug,
        last_delivery_date: now - 1.month,
        next_delivery_date: now
      )

      visit medications_home_delivery_prescriptions_path(named_filter: :esa)

      expect(page).to have_content(patient.to_s)
      expect(page).to have_content(patient.nhs_number)
      expect(page).to have_content("ESA")
      expect(page).to have_content(prescription.drug_name)
      expect(page).to have_content(l(prescription.prescribed_on))
      expect(page).to have_content("01-Nov-2020")
      expect(page).to have_content("01-Dec-2020")
    end
  end

  it "displays matching immunosuppressant prescriptions" do
    travel_to Date.parse("01-12-2020") do
      now = Time.zone.now
      user = login_as_admin
      patient = create(:patient)
      prescription = create_home_delivery_prescription(
        patient,
        user,
        immuno_drug,
        last_delivery_date: now - 1.month,
        next_delivery_date: now
      )

      visit medications_home_delivery_prescriptions_path(named_filter: :immunosuppressant)

      expect(page).to have_content(patient.to_s)
      expect(page).to have_content(patient.nhs_number)
      expect(page).to have_content("Immunosuppressant")
      expect(page).to have_content(prescription.drug_name)
      expect(page).to have_content(l(prescription.prescribed_on))
      expect(page).to have_content("01-Nov-2020")
      expect(page).to have_content("01-Dec-2020")
    end
  end
end
