# frozen_string_literal: true

module Renalware::System
  describe UpdateUser do
    describe "#call" do
      let(:super_admin) { create(:role, :super_admin) }
      let(:adapter) { ActiveJob::Base.queue_adapter }

      before do
        ActiveJob::Base.queue_adapter = :test
        ActiveJob::Base.queue_adapter.enqueued_jobs.clear
      end

      context "with an unapproved user" do
        subject(:commmand) { described_class.new(user) }

        let(:user) { create(:user, :clinical, :unapproved) }

        it "approves the user" do
          allow(user).to receive(:approved=)

          commmand.call(approved: "true")

          expect(user).to have_received(:approved=).with(true)
        end

        it "authorises the user" do
          allow(user).to receive(:roles=)

          commmand.call(approved: "true", roles: [super_admin])

          expect(user).to have_received(:roles=).with([super_admin])
        end

        it "notifies the user of approval" do
          commmand.call(approved: "true", roles: [super_admin])
          expect(adapter.enqueued_jobs.size).to eq(1)
        end

        it "does not approve a user without roles" do
          actual = commmand.call(approved: "true", roles: [])
          expect(actual).to be false
        end
      end

      context "with an approved user" do
        subject(:command) { described_class.new(user) }

        let(:user) { create(:user) }

        it "skips approval" do
          allow(command).to receive(:approve)

          command.call(approved: "true")

          expect(command).not_to have_received(:approve)
        end

        it "does not send an email" do
          expect {
            command.call(approved: "true")
          }.not_to change(adapter.enqueued_jobs, :size)
        end

        it "authorises the user" do
          allow(user).to receive(:roles=)

          command.call(approved: "true", roles: [super_admin])

          expect(user).to have_received(:roles=).with([super_admin])
        end
      end

      context "with an expired user" do
        subject(:command) { described_class.new(user) }

        let(:user) { build(:user, :expired) }

        it "unexpires the user" do
          allow(user).to receive(:expired_at=)

          command.call(unexpire: "true")

          expect(user).to have_received(:expired_at=).with(nil)
        end

        it "notifies the user of account reactivation" do
          expect {
            command.call(unexpire: "true")
          }.to change(adapter.enqueued_jobs, :size).by(1)
        end
      end

      context "with an unexpired user" do
        subject(:command) { described_class.new(user) }

        let(:user) { build(:user) }

        it "skips unexpiry" do
          allow(command).to receive(:unexpire)

          command.call(unexpire: "true")

          expect(command).not_to have_received(:unexpire)
        end

        it "does not send an email" do
          expect {
            command.call(unexpire: "true")
          }.not_to change(adapter.enqueued_jobs, :size)
        end
      end

      context "with an non-consultant user" do
        it "assigns them the consultant flag" do
          user = build(:user, consultant: false)

          described_class.new(user).call(consultant: "true")

          expect(user.reload.consultant).to be(true)
        end

        it "does not send an email" do
          user = build(:user, consultant: false)
          expect {
            described_class.new(user).call(consultant: "true")
          }.not_to change(adapter.enqueued_jobs, :size)
        end
      end

      context "with an consultant user" do
        it "can remove the consultant flag" do
          user = build(:user, consultant: true)

          described_class.new(user).call(consultant: "bla")

          expect(user.reload.consultant).to be(false)
        end

        it "does not send an email" do
          user = build(:user, consultant: true)

          expect {
            described_class.new(user).call(consultant: "bla")
          }.not_to change(adapter.enqueued_jobs, :size)
        end
      end

      context "with a locked user" do
        subject(:command) { described_class.new(user) }

        let(:user) { create(:user, :access_locked) }

        it "unlocks access" do
          expect(user.access_locked?).to be true

          command.call(access_unlock: "true")

          expect(user.access_locked?).to be false
        end
      end
    end
  end
end
