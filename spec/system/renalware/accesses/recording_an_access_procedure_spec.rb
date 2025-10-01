describe "Recording an access procedure for a patient" do
  let(:clinician) { create(:user, :clinical) }
  let(:patient) { create(:patient) }
  let(:accesses_patient) { Renalware::Accesses.cast_patient(patient) }

  before do
    login_as(clinician)
  end

  describe "creating an access procedure" do
    it "allows a clinician to record an access procedure" do
      access_type = create(:access_type)
      insertion_technique = create(:catheter_insertion_technique)
      procedure_page = Pages::Accesses::ProcedurePage.new(accesses_patient)

      procedure_page.visit_add
      procedure_page.performed_on = I18n.l(Time.zone.today)
      procedure_page.performed_by = clinician.to_s
      procedure_page.procedure_type = access_type.to_s
      procedure_page.side = "Right"
      procedure_page.catheter_insertion_technique = insertion_technique.description
      procedure_page.save

      # Verify procedure was created
      expect(accesses_patient.procedures.first).to be_present
      procedure = accesses_patient.procedures.first
      expect(procedure.type).to eq(access_type)
      expect(procedure.side).to eq("right")
      expect(procedure.performed_on).to eq(Time.zone.today)
      expect(procedure.performed_by).to eq(clinician.to_s)
    end
  end

  describe "updating an access procedure" do
    let(:access_type) { create(:access_type) }
    let(:procedure) do
      accesses_patient.procedures.create!(
        type: access_type,
        performed_on: Time.zone.today,
        performed_by: clinician,
        side: :right,
        by: clinician
      )
    end

    it "allows a clinician to update an existing access procedure" do
      procedure # Create the procedure
      procedure_page = Pages::Accesses::ProcedurePage.new(accesses_patient)

      procedure_page.visit_edit
      procedure_page.side = "Left"
      procedure_page.save

      # Verify procedure was updated
      expect(procedure.reload.side).to eq("left")
    end
  end

  describe "validation handling" do
    it "does not accept erroneous access procedure submissions" do
      procedure_page = Pages::Accesses::ProcedurePage.new(accesses_patient)

      procedure_page.visit_add
      # Leave required fields empty and try to save
      procedure_page.save

      # Verify no procedure was created due to validation errors
      expect(accesses_patient.procedures.count).to eq(0)
    end
  end
end
