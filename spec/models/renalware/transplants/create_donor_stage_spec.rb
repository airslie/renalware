# frozen_string_literal: true

module Renalware
  module Transplants
    describe CreateDonorStage do
      describe "#call" do
        # rubocop:disable Metrics/AbcSize
        def validate_stage(stage, position, status, user, options)
          expect(stage).to be_present
          expect(stage.stage_position.name).to eq(position.name)
          expect(stage.stage_status.name).to eq(status.name)
          expect(stage.created_by_id).to eq(user.id)
          expect(stage.created_at).to be_present
          expect(stage.started_on.change(usec: 0)).to eq(options[:started_on].change(usec: 0))
        end
        # rubocop:enable Metrics/AbcSize

        context "when the donor has no status" do
          it "creates a new status" do
            patient = create(:transplant_patient)
            user = create(:user)
            position = create(:donor_stage_position, name: "P")
            status = create(:donor_stage_status, name: "S")
            expect(DonorStage.for_patient(patient).count).to eq(0)

            options = {
              stage_position_id: position.id,
              stage_status_id: status.id,
              started_on: Time.zone.now,
              notes: "Some notes",
              by: user
            }

            described_class.new(patient: patient, options: options).call

            stages = DonorStage.for_patient(patient).all
            expect(stages.length).to eq(1)
            stage = stages.first
            validate_stage(stage, position, status, user, options)
            expect(stage.terminated_on).to be_nil
          end
        end

        context "when the donor already has a status" do
          it "terminates the old status and creates a new one" do
            patient = create(:transplant_patient)
            user = create(:user)
            status = create(:donor_stage_status, name: "S")
            position1 = create(:donor_stage_position, name: "A")
            position2 = create(:donor_stage_position, name: "B")
            existing_status = DonorStage.new(patient: patient,
                                             stage_position: position1,
                                             stage_status: status,
                                             started_on: Time.zone.now - 1.day,
                                             by: user)
            existing_status.save!
            expect(DonorStage.for_patient(patient).count).to eq(1)

            options = {
              stage_position_id: position2.id,
              stage_status_id: status.id,
              started_on: Time.zone.now,
              notes: "Some notes",
              by: user
            }
            result = described_class.new(patient: patient, options: options).call

            expect(result).to be_success

            stages = DonorStage.for_patient(patient).order(created_at: :desc).all
            expect(stages.length).to eq(2)

            # The new one
            stage = stages.first
            validate_stage(stage, position2, status, user, options)
            expect(stage.terminated_on).to be_nil

            # The terminated one
            stage = stages.last
            validate_stage(stage,
                           position1,
                           status,
                           user,
                           started_on: existing_status.started_on)
            expect(stage.terminated_on.change(usec: 0)).to eq(options[:started_on].change(usec: 0))
          end
        end
      end
    end
  end
end
