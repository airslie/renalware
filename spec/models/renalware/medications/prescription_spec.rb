module Renalware
  module Medications
    describe Prescription do
      subject(:prescription) { described_class.new }

      it_behaves_like "an Accountable model"

      describe "validations" do
        it :aggregate_failures do
          is_expected.to validate_presence_of :patient
          is_expected.to validate_presence_of :treatable_type
          is_expected.to validate_presence_of :treatable_id
          is_expected.to validate_presence_of(:drug)
          is_expected.to validate_presence_of(:dose_amount)
          is_expected.to validate_presence_of(:medication_route)
          is_expected.to validate_presence_of(:frequency)
          is_expected.to validate_presence_of(:prescribed_on)
          is_expected.to validate_presence_of(:provider)
          is_expected.to belong_to(:patient).touch(true)
          is_expected.to respond_to(:last_delivery_date)
          is_expected.to be_versioned
        end
      end

      describe "scopes" do
        before do
          create_prescription(notes: ":expires_today:", terminated_on: "2024-01-02")
          create_prescription(notes: ":expired_yesterday:", terminated_on: "2024-01-01")
          create(:prescription, notes: ":not_specified:")
          create_prescription(notes: ":expires_tomorrow:", terminated_on: "2024-01-03")
        end

        describe ".current" do
          subject(:prescriptions) { described_class.current("2024-01-02") }

          it "returns prescriptions that terminate today or later, or not specified" do
            expect(prescriptions.map(&:notes)).to \
              include(":expires_tomorrow:", ":not_specified:")
            expect(prescriptions.map(&:notes)).not_to \
              include(":expires_today:", ":expires_yesterday:")
          end
        end

        describe ".terminated" do
          subject(:prescriptions) { described_class.terminated("2024-01-02") }

          it "returns prescriptions that terminate today or later, or not specified" do
            expect(prescriptions.map(&:notes)).to \
              include(":expires_today:", ":expired_yesterday:")
            expect(prescriptions.map(&:notes)).not_to \
              include(":expires_tomorrow:", ":not_specified:")
          end
        end

        describe ".to_be_administered_on_hd" do
          it "returns only current but non-future prescriptions flagged as administer_on_hd" do
            freeze_time do
              tomorrow = Date.current + 1.day
              yesterday = Date.current - 1.day
              create_prescription(administer_on_hd: false,
                                  terminated_on: tomorrow,
                                  prescribed_on: 2.months.ago,
                                  notes: ":expires_tomorrow:")
              target = create_prescription(administer_on_hd: true,
                                           terminated_on: tomorrow,
                                           prescribed_on: 2.months.ago,
                                           notes: ":expires_tomorrow:")
              create_prescription(administer_on_hd: true,
                                  terminated_on: yesterday,
                                  prescribed_on: 2.months.ago,
                                  notes: ":expired_yesterday:")
              _future = create_prescription(administer_on_hd: true,
                                            prescribed_on: tomorrow,
                                            terminated_on: 2.weeks.since,
                                            notes: ":starts_tomorrow:")

              prescriptions = described_class.to_be_administered_on_hd
              expect(prescriptions.length).to eq(1)
              expect(prescriptions.first.administer_on_hd).to be(true)
              expect(prescriptions.first).to eq(target)
            end
          end
        end
      end

      describe "state predicates" do
        let(:date_today) { Date.parse("2010-01-02") }

        describe "#current?" do
          context "when the termination date is today" do
            let(:prescription) { build_prescription(terminated_on: "2010-01-02") }

            it { expect(prescription).to be_current(date_today) }
          end

          context "when the termination date is after today" do
            let(:prescription) { build_prescription(terminated_on: "2010-01-03") }

            it { expect(prescription).to be_current(date_today) }
          end

          context "when the termination date is before today" do
            let(:prescription) { build_prescription(terminated_on: "2010-01-01") }

            it { expect(prescription).not_to be_current(date_today) }
          end
        end

        describe "#terminated_or_marked_for_termination?" do
          context "when the termination date is in the future" do
            let(:prescription) { build_prescription(terminated_on: Date.current + 1.minute) }

            it { expect(prescription).to be_terminated_or_marked_for_termination }
          end

          context "when the termination date is in the past" do
            let(:prescription) { build_prescription(terminated_on: Date.current - 1.minute) }

            it { expect(prescription).to be_terminated_or_marked_for_termination }
          end

          context "when the termination date is not specified" do
            let(:prescription) { build(:prescription) }

            it { expect(prescription).not_to be_terminated_or_marked_for_termination }
          end
        end
      end

      describe "entity services" do
        describe "#terminate" do
          context "with an active prescription" do
            subject(:active_prescription) { build(:prescription, prescribed_on: "2009-01-01") }

            let(:user) { build(:user) }
            let(:terminated_on) { Date.parse("2010-10-10") }

            it "records the termination" do
              termination = active_prescription.terminate(by: user, terminated_on: terminated_on)

              expect(termination.terminated_on).to eq(terminated_on)
              expect(termination).to be_valid
            end
          end
        end
      end

      def build_prescription(terminated_on:)
        build(
          :prescription,
          prescribed_on: "2024-01-01",
          termination: build(
            :prescription_termination,
            terminated_on: terminated_on
          )
        )
      end

      def create_prescription(
        terminated_on:,
        notes: nil,
        administer_on_hd: false,
        prescribed_on: "2024-01-01"
      )
        create(
          :prescription,
          prescribed_on: prescribed_on,
          notes: notes,
          administer_on_hd: administer_on_hd,
          termination: build(:prescription_termination, terminated_on: terminated_on)
        )
      end
    end
  end
end
