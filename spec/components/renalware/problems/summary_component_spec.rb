describe Renalware::Problems::SummaryComponent, type: :component do
  let(:user) { create(:user) }
  let(:patient) { create(:patient, by: user) }

  describe "#cache_key" do
    let(:component) { described_class.new(patient: patient, current_user: user) }

    it "has a useful value that references the patient and problems in some way" do
      expect(component.cache_key).to match("/patients/")
      expect(component.cache_key).to match("/problems/")
    end

    it "does not change when the patient is reloaded" do
      expect {
        patient.reload
      }.not_to change(component, :cache_key)
    end

    it "changes when the patient is touched" do
      expect {
        patient.touch
      }.to change(component, :cache_key)
    end

    it "changes when a problem is touched" do
      create(:problem, patient: patient, by: user)

      expect {
        patient.problems.first.touch
        patient.reload
      }.to change(component, :cache_key)
    end

    it "changes when a problem is added" do
      expect {
        create(:problem, patient: patient, by: user)
      }.to change(component, :cache_key)
    end

    it "changes when a problem is removed" do
      create(:problem, patient: patient, by: user)

      expect {
        patient.problems.first.destroy!
        patient.reload
      }.to change(component, :cache_key)
    end

    it "changes when a note is added to a problem" do
      create(:problem, patient: patient, by: user)

      expect {
        patient.problems.first.notes.create!(description: "123", by: user)
        patient.reload
      }.to change(component, :cache_key)
    end

    it "changes when a note is removed from a problem" do
      create(:problem, patient: patient, by: user)
      patient.problems.first.notes.create!(description: "123", by: user)

      expect {
        patient.problems.first.notes.first.destroy!
        patient.reload
      }.to change(component, :cache_key)
    end

    it "changes when a problem note is touched" do
      create(:problem, patient: patient, by: user)
      patient.problems.first.notes.create!(description: "123", by: user)
      patient.reload

      expect {
        patient.problems.first.notes.first.touch
        patient.reload
      }.to change(component, :cache_key)
    end
  end
end
