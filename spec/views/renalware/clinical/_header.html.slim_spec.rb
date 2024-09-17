# frozen_string_literal: true

describe "renalware/clinical/header" do
  let(:patient) { create(:patient) }

  def my_t(key)
    I18n.t(key, scope: "renalware.clinical.header")
  end

  it "displays the correct latest clinical observations", :aggregate_failures do
    create(
      :clinic_visit,
      patient_id: patient.id,
      weight: 100.99,
      height: 1.99,
      systolic_bp: 123,
      diastolic_bp: 91
    )
    render partial: "renalware/clinical/header", locals: { patient: patient }

    expect(rendered).to include my_t("blood_pressure")
    expect(rendered).to include my_t("weight")
    expect(rendered).to include my_t("height")
    expect(rendered).to include my_t("bmi")
    expect(rendered).to include("100.99")
    expect(rendered).to include("1.99")
    expect(rendered).to include("123/91")
  end

  it "displays the correct latest pathology" do
    path_codes = %i(hgb cre pot egfr ure)
    date = Time.zone.now.to_date
    path = path_codes.each_with_object({}) do |code, hash|
      hash[:"#{code}_result"] = "#{code}_result"
      hash[:"#{code}_observed_at"] = date
    end

    # rubocop:disable RSpec/VerifiedDoubles
    # We can't use instance_double here as methods we need like #hgb_result are meta-programmed.
    current_pathology = double(current_pathology, path)
    # rubocop:enable RSpec/VerifiedDoubles

    presenter = Renalware::Clinical::HeaderPresenter.new(patient)
    allow(presenter).to receive(:current_pathology).and_return(current_pathology)
    render partial: "renalware/clinical/header", locals: { patient: patient, header: presenter }

    path_codes.each do |code|
      expect(rendered).to include t(code, scope: "renalware.clinical.header")
      expect(rendered).to include "#{code}_result"
      expect(rendered).to include(l(date, format: :compact))
    end
  end
end
