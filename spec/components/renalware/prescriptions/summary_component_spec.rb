module Renalware::Prescriptions
  describe SummaryComponent do
    subject(:component) { described_class.new(patient: patient) }

    let(:user) { create(:user) }
    let(:patient) { create(:letter_patient, by: user) }
    let(:default_drug) { create(:drug, name: "::drug name::") }

    def terminated_prescription(terminated_on:, drug: default_drug)
      create(:prescription,
             patient: patient,
             drug: drug,
             prescribed_on: "2009-01-01",
             termination: build(:prescription_termination, terminated_on: terminated_on),
             by: user)
    end

    def current_prescription(
      prescribed_on: "2009-01-01",
      drug: default_drug,
      administer_on_hd: false
    )
      create(:prescription,
             patient: patient,
             drug: drug,
             prescribed_on: prescribed_on,
             updated_at: prescribed_on,
             created_at: prescribed_on,
             administer_on_hd: administer_on_hd,
             by: user)
    end

    describe "self" do
      it "returns an OpenStruct of different sets of prescriptions" do
        expect(component).to respond_to(:current)
        expect(component).to respond_to(:current_hd)
        expect(component).to respond_to(:recently_changed)
        expect(component).to respond_to(:recently_stopped)
      end
    end

    describe "#current" do
      it "comprises only current prescriptions" do
        terminated_prescription(terminated_on: Time.zone.today - 1.day)
        current_prescription(administer_on_hd: true)
        current_non_hd = current_prescription(administer_on_hd: false)

        expect(component.current.to_a).to eq([current_non_hd])
      end
    end

    describe "#recently_changed" do
      it "comprises only prescriptions changed in the last 14 days" do
        terminated_prescription(terminated_on: 1.day.ago)
        current_prescription(prescribed_on: 15.days.ago)
        recently_changed = current_prescription(prescribed_on: 13.days.ago)
        recently_changed_hd =
          current_prescription(prescribed_on: 12.days.ago, administer_on_hd: true)

        expect(component.recently_changed.to_a.sort).to eq([recently_changed, recently_changed_hd])
      end
    end

    describe "#recently_stopped" do
      it "comprises prescriptions stopped within the last 14 days having a drug which is not in " \
         "the #current list" do
        other_drug = create(:drug, name: "a drug not in the current list")

        # No as not terminated
        current_prescription
        # No we already have drug in current list
        terminated_prescription(terminated_on: 13.days.ago)
        # No as not within 14 days
        terminated_prescription(terminated_on: 15.days.ago)
        # YES as terminated and drug not in current list
        recently_stopped_prescription = terminated_prescription(terminated_on: 13.days.ago,
                                                                drug: other_drug)

        expect(component.recently_stopped.to_a).to eq([recently_stopped_prescription])
      end
    end

    describe "#current_hd" do
      it "comprises current prescriptions to give on HD only" do
        patient.prescriptions << terminated_prescription(terminated_on: Time.zone.today - 1.day)
        current_prescription(administer_on_hd: false)
        current_hd_prescription = current_prescription(administer_on_hd: true)

        expect(component.current_hd.to_a).to eq([current_hd_prescription])
      end
    end
  end
end
