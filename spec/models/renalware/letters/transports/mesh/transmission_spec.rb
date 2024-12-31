module Renalware::Letters::Transports::Mesh
  describe Transmission do
    include LettersSpecHelper

    let(:user) { create(:user) }
    let(:practice) { create(:practice) }
    let(:gp) { create(:letter_primary_care_physician, practices: [practice]) }
    let(:patient) do
      create(:letter_patient,
             practice: practice,
             primary_care_physician: gp,
             by: user)
    end
    let(:letter) do
      create_letter(state: :approved,
                    to: :primary_care_physician,
                    patient: patient,
                    author: user,
                    by: user)
    end

    it { is_expected.to validate_presence_of(:letter) }
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to have_many(:operations) }
    it { is_expected.to have_db_index(:letter_id) }
    it { is_expected.to have_db_index(:status) }
    it { is_expected.to have_db_index(:active_job_id) }

    it "sanity check object creation" do
      transmission = create(:letter_mesh_transmission, letter: letter)

      expect(transmission).to have_attributes(
        letter_id: letter.id,
        status: "pending",
        comment: nil
      )
      expect(transmission.uuid).to be_present # defaults to new uuid
      expect(transmission.operations).to be_empty # no actions taken yet
    end

    describe "#cancellable scope" do
      it "returns only status: pending transmissions" do
        %w(pending success failure).each do |status| # TODO: add cancelled
          create(:letter_mesh_transmission, letter: letter, status: status)
        end

        expect(described_class.cancellable.map(&:status)).to eq(["pending"])
      end

      it "ignores pending transmissions that have operations - ie they might be in progress" do
        transmission = create(:letter_mesh_transmission, letter: letter, status: "pending")
        transmission.operations.create!(action: :endpointlookup, direction: :outbound)

        expect(described_class.cancellable.size).to eq(0)
      end
    end

    describe "#cancel_pending" do
      it "Uses the #cancellable scope" do
        allow(described_class).to receive(:cancellable).and_return(described_class.all)

        described_class.cancel_pending(letter: letter)

        expect(described_class).to have_received(:cancellable)
      end

      context "when the transmission status is not pending" do
        %w(success failure).each do |status| # TODO: add cancelled
          it status do
            transmission = create(:letter_mesh_transmission, letter: letter, status: status)

            expect {
              described_class.cancel_pending(letter: letter)
            }.not_to change(transmission, :status)
          end
        end
      end

      context "when the transmission status is pending" do
        it "marks the transmission as cancelled" do
          transmission = create(:letter_mesh_transmission, letter: letter, status: "pending")

          freeze_time do
            described_class.cancel_pending(letter: letter)
            pending
            expect(transmission.reload).to have_attributes(
              status: "cancelled",
              cancelled_at: Time.zone.now
            )
          end
        end

        it "marks the transmissions as cancelled if more than one for this letter" do
          transmission1 = create(:letter_mesh_transmission, letter: letter, status: "pending")
          transmission2 = create(:letter_mesh_transmission, letter: letter, status: "pending")

          described_class.cancel_pending(letter: letter)
          pending "todo"
          expect(transmission1.reload.status).to eq("cancelled")
          expect(transmission2.reload.status).to eq("cancelled")
        end

        it "ignores pending transmission for other letters" do
          letter2 = create_letter(state: :approved,
                                  to: :primary_care_physician,
                                  patient: patient,
                                  author: user,
                                  by: user)
          transmission2 = create(:letter_mesh_transmission, letter: letter2, status: "pending")
          transmission = create(:letter_mesh_transmission, letter: letter, status: "pending")

          pending "todo"

          expect {
            described_class.cancel_pending(letter: letter)
            transmission.reload
            transmission2.reload
          }.to change(transmission, :status).to("cancelled")
            .and not_change(transmission2, :status)
        end
      end
    end
  end
end
