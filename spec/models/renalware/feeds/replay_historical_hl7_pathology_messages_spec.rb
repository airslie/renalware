# frozen_string_literal: true

module Renalware
  module Feeds
    describe ReplayHistoricalHL7PathologyMessages do
      let(:hl7) do
        <<-HL7.squish
          MSH|^~\&|HM|RAJ01|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
          PID||7179209791^NHS|Z100002^^^KCH||RABBIT^JESSICA^^^MS||19480922|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR||||||||||||||||||201010102359|
          ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
          OBR|1|^PCS|09B0099478^LA|XBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
          OBX|1|TX|CRE^CRE^HM||23||||||F|||201801151249||BHISVC01^BHI Authchecker
        HL7
      end

      context "when feed_messages are replayed successfully" do
        it do
          allow(MessageParser).to receive(:parse).and_return(NullObject.instance)
          feed_message = Message.create!(
            nhs_number: "0123456789",
            dob: "2001-01-01",
            body: "test",
            message_type: :ORU,
            event_type: :R01,
            processed: nil,
            orc_order_status: "CM",
            orc_filler_order_number: "ORC123",
            sent_at: 1.day.ago,
            header_id: "ABC"
          )
          patient = create(:patient, nhs_number: "0123456789", born_on: "2001-01-01")

          freeze_time do
            now = Time.zone.now
            # skip broadcasting_to_configured_subscribers which happens in class.call
            expect {
              described_class.new(patient: patient).call
            }
              .to change(ReplayRequest, :count).by(1)
              .and change(MessageReplay, :count).by(1)

            replay_request = ReplayRequest.last
            expect(replay_request).to have_attributes(
              started_at: now,
              finished_at: now,
              total_messages: 1,
              failed_messages: 0
            )

            expect(replay_request.message_replays.last).to have_attributes(
              message: feed_message,
              urn: "ORC123",
              success: true,
              error_message: nil
            )
          end
        end

        context "when one feed_message signals an error during replay" do
          # rubocop:disable RSpec/ExampleLength
          it "flags that one as failed" do
            feed_message_fail = Message.create!(
              nhs_number: "0123456789",
              dob: "2001-01-01",
              body: "BAD HL7",
              message_type: :ORU,
              event_type: :R01,
              processed: nil,
              orc_order_status: "CM",
              header_id: "123",
              orc_filler_order_number: "123",
              sent_at: 1.day.ago
            )
            feed_message_ok = Message.create!(
              nhs_number: "0123456789",
              dob: "2001-01-01",
              body: hl7,
              message_type: :ORU,
              event_type: :R01,
              processed: nil,
              orc_order_status: "CM",
              header_id: "123",
              orc_filler_order_number: "456",
              sent_at: 1.day.ago
            )
            patient = create(:patient, nhs_number: "0123456789", born_on: "2001-01-01")
            # allow(MessageParser).to receive(:parse).and_return(NullObject.instance)

            freeze_time do
              now = Time.zone.now
              replay_request = nil
              # skip broadcasting_to_configured_subscribers which happens in class.call
              expect {
                replay_request = described_class.new(patient: patient).call
              }
                .to change(ReplayRequest, :count).by(1)
                .and change(MessageReplay, :count).by(2)

              expect(replay_request).to eq(ReplayRequest.last)
              expect(ReplayRequest.last).to have_attributes(
                started_at: now,
                finished_at: now,
                total_messages: 2,
                failed_messages: 1
              )

              expect(MessageReplay.first).to have_attributes(
                success: false,
                message: feed_message_fail,
                error_message: /undefined method `message_type' for nil/
              )

              expect(MessageReplay.last).to have_attributes(
                success: true,
                message: feed_message_ok,
                error_message: nil
              )
            end
            # rubocop:enable RSpec/ExampleLength
          end
        end
      end

      # rubocop:disable RSpec/ExampleLength
      context "when a replay is run twice for the same patient" do
        it "retries any failed message_replays from a previous attempt" do
          shared_attrs = {
            nhs_number: "0123456789",
            dob: "2001-01-01",
            body: hl7,
            message_type: :ORU,
            event_type: :R01,
            processed: nil,
            orc_order_status: "CM",
            header_id: "123"
          }
          patient = create(
            :patient,
            nhs_number: "0123456789",
            born_on: "2001-01-01",
            created_at: 1.hour.from_now
          )
          feed_message_succ = Message.create!(
            sent_at: 2.days.ago,
            orc_filler_order_number: "succ",
            **shared_attrs
          )
          feed_message_fail = Message.create!(
            sent_at: 2.days.ago,
            orc_filler_order_number: "fail",
            **shared_attrs
          )
          rr = ReplayRequest.create!(
            patient: patient,
            started_at: Time.zone.now,
            finished_at: Time.zone.now
          )
          _mr_success = MessageReplay.create!(
            message: feed_message_succ,
            urn: feed_message_succ.orc_filler_order_number,
            replay_request: rr,
            success: true
          )
          _mr_failure = MessageReplay.create!(
            message: feed_message_fail,
            urn: feed_message_fail.orc_filler_order_number,
            replay_request: rr,
            success: false
          )
          expect {
            described_class.new(patient: patient).call
          }.to change(ReplayRequest, :count).by(1)
            .and change(MessageReplay, :count).by(1)

          expect(MessageReplay.last.message_id).to eq(feed_message_fail.id)
        end

        it "behaves idempotently and does not find more messages the second time" do
          shared_attrs = {
            nhs_number: "0123456789",
            dob: "2001-01-01",
            body: hl7,
            message_type: :ORU,
            event_type: :R01,
            processed: nil,
            orc_order_status: "CM",
            header_id: "123",
            orc_filler_order_number: "123"
          }
          feed_message_latest = Message.create!(sent_at: 2.days.ago, **shared_attrs)
          _feed_message_ignore_me = Message.create!(sent_at: 3.days.ago, **shared_attrs)
          patient = create(
            :patient,
            nhs_number: "0123456789",
            born_on: "2001-01-01",
            created_at: 1.day.from_now
          )

          # The first time we run it it should find the single de-duplicated (distinct on
          # orc_filler_order_number) most recent (order by sent_at desc)
          # feed message and create
          # a) 1 ReplayRequest for the whole operation
          # b) 1 MessageReplay for that single found message
          expect {
            described_class.new(patient: patient).call
          }.to change(ReplayRequest, :count).by(1)
            .and change(MessageReplay, :count).by(1)

          expect(MessageReplay.last.message_id).to eq(feed_message_latest.id)

          # If we run it again, it should behave idempotently and not try and import any other #
          # messages. We should see
          # a) 1 ReplayRequest for the whole operation
          # b) 0 MessageReplays
          expect {
            described_class.new(patient: patient).call
          }.to change(ReplayRequest, :count).by(1)
            .and not_change(MessageReplay, :count)

          # Now add another message with the same orc_filler_order_number. Even though
          # this is a newer one, as we have already imported an orc_order_status=CM one with this
          # orc_filler_order_number, we will ignore it. I don't think this is an issue.
          _newer_feed_message = Message.create!(sent_at: 1.day.ago, **shared_attrs)

          expect {
            described_class.new(patient: patient).call
          }.to change(ReplayRequest, :count).by(1)
            .and not_change(MessageReplay, :count)

          # However if we add another message with a different orc_filler_order_number, it should
          # be found if we run it again
          _feed_message = Message.create!(
            sent_at: 1.day.ago,
            **shared_attrs,
            orc_filler_order_number: "456"
          )
          expect {
            described_class.new(patient: patient).call
          }.to change(ReplayRequest, :count).by(1)
            .and change(MessageReplay, :count).by(1)
        end
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end
end
