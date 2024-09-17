# frozen_string_literal: true

module Renalware::Medications
  describe RenewPrescription do
    let(:patient) { create(:patient) }
    let(:user) { create(:user) }
    let(:drug) { create(:drug) }
    let(:uncopyable_attributes) {
      %w(
        id
        prescribed_on
        created_at
        updated_at
        created_by_id
        updated_by_id
      )
    }

    it "raises an error if by (current_user) is nil" do
      prescription = build(:prescription, administer_on_hd: true)

      expect {
        described_class.call(
          prescription: prescription,
          auto_terminate_after: 3.months,
          by: nil
        )
      }.to raise_error(ArgumentError)
    end

    it "raises an error if prescription is nil" do
      expect {
        described_class.call(
          prescription: nil,
          auto_terminate_after: 3.months,
          by: user
        )
      }.to raise_error(ArgumentError)
    end

    it "raises an error if the auto_terminate_after is nil" do
      prescription = build(:prescription, administer_on_hd: true)

      expect {
        described_class.call(
          prescription: prescription,
          auto_terminate_after: nil,
          by: user
        )
      }.to raise_error(ArgumentError)
    end

    it "raises an error if the prescription is not 'administer_on_hd'" do
      # This is a sanity check and could be removed once its clear if/how RenewPrescription
      # could be reused for other 'types' of prescription
      prescription = build(:prescription, administer_on_hd: false)

      expect {
        described_class.call(
          prescription: prescription,
          auto_terminate_after: 3.months,
          by: user
        )
      }.to raise_error(ArgumentError, "Prescription must be administer_on_hd=true")
    end

    context "when the prescription does not have a (future) termination associated with it" do
      it "terminates the prescription with today's date, and creates a new one with a termination" \
         "date set according to the the auto_terminate_after attr" do
        period = 3.months

        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(period)

        prescription = create(
          :prescription,
          patient: patient,
          drug: drug,
          administer_on_hd: true,
          prescribed_on: 1.day.ago
        )

        expect {
          described_class.call(
            prescription: prescription,
            auto_terminate_after: period,
            by: user
          )
        }.to change(PrescriptionTermination, :count).by(2)
          .and change(Prescription, :count).by(1)

        terminated_prescription = prescription.reload
        expect(terminated_prescription.termination).to have_attributes(
          updated_by_id: user.id,
          terminated_on: Time.zone.today
        )
        new_prescription = Prescription.last

        # check all attributes copied across to new one
        original_attributes = terminated_prescription.attributes.except(*uncopyable_attributes)
        expect(new_prescription).to have_attributes(**original_attributes)

        # check prescribed_on set to today
        expect(new_prescription.prescribed_on).to eq(Time.zone.today)

        # Check the termination set up with the correct end date
        expect(new_prescription.termination).to have_attributes(
          terminated_on: new_prescription.prescribed_on + period,
          created_by_id: user.id,
          updated_by_id: user.id
        )
      end

      it "does not error if the old prescription was prescribed > [max renew period] ago" do
        # If the prescribed_on is 6 months and period is 3m, setting the termination date to
        # today would cause a validation error
        # (see validates :terminated_on PrescriptionTermination)
        # so here we are testing that that condition does ot stop an HD prescription from being
        # terminated.
        period = 3.months

        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(period)

        # Create an unterminated HD prescription way back
        prescription = create(
          :prescription,
          patient: patient,
          drug: drug,
          administer_on_hd: true,
          prescribed_on: 6.months.ago
        )

        # Now attempt to renew it which will terminate it (ignoring the validation)
        expect {
          described_class.call(
            prescription: prescription,
            auto_terminate_after: period,
            by: user
          )
        }.to change(PrescriptionTermination, :count).by(2)
          .and change(Prescription, :count).by(1)
      end
    end

    # context "when the prescription has a future start and stop dates" do
    #   it do
    #     period = 3.months

    #     allow(Renalware.config)
    #       .to receive(:auto_terminate_hd_prescriptions_after_period)
    #       .and_return(period)

    #     create(
    #       :prescription,
    #       patient: patient,
    #       drug: drug,
    #       administer_on_hd: true,
    #       prescribed_on: 10.days.from_now
    #     )
    #   end
    # end

    context "when the prescription already has a (future) termination" do
      it "updates the termination with today's date and creates a new one with a termination " \
         "date set according to the the auto_terminate_after attr" do
        period = 3.months

        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(period)

        prescription = create(
          :prescription,
          patient: patient,
          drug: drug,
          administer_on_hd: true,
          prescribed_on: 1.day.ago
        )
        create(
          :prescription_termination,
          prescription: prescription,
          terminated_on: 1.week.from_now
        )

        expect {
          described_class.call(
            prescription: prescription,
            auto_terminate_after: period,
            by: user
          )
        }.to change(PrescriptionTermination, :count).by(1)
          .and change(Prescription, :count).by(1)

        terminated_prescription = prescription.reload
        expect(terminated_prescription.termination).to have_attributes(
          updated_by_id: user.id,
          terminated_on: Time.zone.today
        )
        new_prescription = Prescription.last

        # check all attributes copied across to new one
        original_attributes = terminated_prescription.attributes.except(*uncopyable_attributes)
        expect(new_prescription).to have_attributes(**original_attributes)

        # check prescribed_on set to today
        expect(new_prescription.prescribed_on).to eq(Time.zone.today)

        # Check the termination set up with the correct end date
        expect(new_prescription.termination).to have_attributes(
          terminated_on: new_prescription.prescribed_on + period,
          created_by_id: user.id,
          updated_by_id: user.id
        )
      end
    end
  end
end
