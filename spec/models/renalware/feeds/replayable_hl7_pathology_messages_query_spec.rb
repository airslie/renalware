# frozen_string_literal: true

module Renalware
  module Feeds
    describe ReplayableHL7PathologyMessagesQuery do
      let(:nhs_num) { "4001540037" }
      let(:other_nhs_num) { "2579228098" }
      let(:dob) { Date.parse("2001-01-01") }

      # rubocop:disable Metrics/MethodLength
      def create_message(
        nhs_number: nil,
        body: "some-hl7#{Time.zone.now.to_i}",
        created_at: Time.zone.now,
        processed: false,
        orc_filler_order_number: SecureRandom.uuid,
        **
      )
        Message.create!(
          nhs_number: nhs_number,
          message_type: :ORU,
          event_type: :R01,
          orc_order_status: "CM",
          header_id: 1,
          body: body,
          orc_filler_order_number: orc_filler_order_number,
          sent_at: Time.zone.now,
          created_at: created_at,
          updated_at: created_at,
          processed: processed,
          **
        )
      end
      # rubocop:enable Metrics/MethodLength

      it "raises an error if patent is not yet saved" do
        patient = build(:patient)

        expect {
          described_class.new(patient: patient).call
        }.to raise_error(ReplayableHL7PathologyMessagesQuery::PatientNotPersistedError)
      end

      it "raises an error if patient dob missing" do
        patient = build(:patient, born_on: nil)
        allow(patient).to receive(:persisted?).and_return(true)

        expect {
          described_class.new(patient: patient).call
        }.to raise_error(ReplayableHL7PathologyMessagesQuery::MissingDOBNumberError)
      end

      it "raises an error if patient has no nhs number or other number" do
        patient = build(
          :patient,
          nhs_number: "",
          local_patient_id: nil,
          local_patient_id_2: "     ",
          local_patient_id_3: nil,
          local_patient_id_4: "",
          local_patient_id_5: nil
        )
        allow(patient).to receive(:persisted?).and_return(true)

        expect {
          described_class.new(patient: patient).call
        }.to raise_error(ReplayableHL7PathologyMessagesQuery::MissingNHSNumberOrLocalIdError)
      end

      it "finds the most recently sent messages distinct on orc_filler_order_number" do
        patient = create(
          :patient,
          nhs_number: nhs_num,
          born_on: dob,
          created_at: 1.hour.from_now
        )
        _patient = create(
          :patient,
          nhs_number: other_nhs_num,
          born_on: dob,
          created_at: 1.hour.from_now
        )

        msg_common_args = {
          nhs_number: patient.nhs_number,
          dob: patient.born_on,
          orc_filler_order_number: "123"
        }
        _msg_mo_match = create_message(nhs_number: other_nhs_num)
        _msg_123_superseded = create_message(sent_at: 2.days.ago, **msg_common_args)
        msg_123_match = create_message(sent_at: 1.day.ago, **msg_common_args)

        results = described_class.new(patient: patient).call

        expect(results.to_a.size).to eq(1)
        expect(results.to_a).to eq([msg_123_match])
      end

      it "can target say two orc filler order numbers specifically" do
        patient = create(:patient, nhs_number: nhs_num, born_on: dob, created_at: 1.hour.from_now)

        msg_common_args = {
          nhs_number: patient.nhs_number,
          dob: patient.born_on,
          orc_filler_order_number: "123"
        }
        msg_a = create_message(**msg_common_args, orc_filler_order_number: "A")
        _msg_b = create_message(**msg_common_args, orc_filler_order_number: "B")
        msg_c = create_message(**msg_common_args, orc_filler_order_number: "C")
        _msg_c_nomatch = create_message(
          nhs_number: other_nhs_num,
          dob: patient.born_on,
          orc_filler_order_number: "C"
        )

        results = described_class.new(patient: patient, orc_filler_order_numbers: %w(A C)).call

        expect(results.to_a.size).to eq(2)
        expect(results.to_a).to eq([msg_a, msg_c])
      end

      it "finds messages by nhs_number + DOB (oldest first) if local_patient_ids don't match" do
        patient = build(
          :patient,
          nhs_number: nhs_num,
          local_patient_id: nil,
          local_patient_id_2: nil,
          local_patient_id_3: nil,
          born_on: dob,
          created_at: 1.hour.from_now
        )

        patient.save!(validate: false) # otherwise it wants at least one local_patient_id*)
        create_message(nhs_number: "nomatch")
        msg_matched1 = create_message(nhs_number: nhs_num, created_at: 1.day.ago, dob: dob)
        msg_matched2 = create_message(
          nhs_number: nhs_num,
          created_at: 2.days.ago,
          dob: dob,
          local_patient_id: "does not match patient's local_patient_id",
          local_patient_id_2: "does not match patient's local_patient_id_2"
        )

        results = described_class.new(patient: patient).call

        expect(results.to_a.size).to eq(2)
        expect(results.to_a).to eq([msg_matched1, msg_matched2])
      end

      %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |local_id_attribute|
        it "finds messages by a patient's #{local_id_attribute} if nhs_number is missing" do
          hospno = local_id_attribute.to_s.upcase # eg "LOCAL_PATIENT_ID_3" - will use as the number
          resets = {
            local_patient_id: nil,
            local_patient_id_2: nil,
            local_patient_id_3: nil,
            local_patient_id_4: nil,
            local_patient_id_5: nil
          }
          patient = create(
            :patient,
            nhs_number: " ",
            born_on: dob,
            **resets.update(local_id_attribute => hospno),
            created_at: 1.hour.from_now
          )
          # This message is for another patient and will never be found
          create_message(local_id_attribute => "nomatch", dob: dob)
          # These 2 messages will be returned, oldest first
          msg_matched2 = create_message(
            local_id_attribute => hospno,
            nhs_number: nil,
            dob: dob,
            created_at: 2.days.ago
          )
          msg_matched1 = create_message(
            local_id_attribute => hospno,
            nhs_number: nil,
            dob: dob,
            created_at: 1.day.ago
          )

          results = described_class.call(patient: patient)

          expect(results.to_a).to eq([msg_matched2, msg_matched1])
        end
      end

      context "when there was a previous successful replay for a message" do
        it "excludes that message" do
          patient = create(:patient, nhs_number: nhs_num, born_on: dob, created_at: 1.hour.from_now)
          opts = { nhs_number: nhs_num, dob: dob }
          msg1 = create_message(**opts, orc_filler_order_number: "one")
          msg2 = create_message(**opts, orc_filler_order_number: "two")
          replay_request = ReplayRequest.create!(started_at: Time.zone.now, patient: patient)
          replay_request.message_replays.create!(message: msg1, success: true, urn: "one")
          replay_request.message_replays.create!(message: msg2, success: true, urn: "two")

          results = described_class.new(patient: patient).call

          expect(results).to be_empty
        end
      end

      context "when there was a previous unsuccessful replay for a message" do
        it "includes that message" do
          patient = create(:patient, nhs_number: nhs_num, born_on: dob, created_at: 1.hour.from_now)
          msg = create_message(
            nhs_number: nhs_num,
            dob: dob,
            processed: false,
            orc_filler_order_number: "123"
          )
          replay_request = ReplayRequest.create!(started_at: Time.zone.now, patient: patient)
          replay_request.message_replays.create!(message: msg, success: true, urn: "123")

          results = described_class.new(patient: patient).call

          expect(results).to be_empty
        end
      end

      context "when finding feed message received before the patient was created in RW" do
        context "when no before argument supplied" do
          it "excludes msgs received after pt creation (these will have already been ingested)" do
            freeze_time do
              patient_created_at = Time.zone.now
              patient = create(
                :patient,
                nhs_number: nhs_num,
                born_on: dob,
                created_at: patient_created_at
              )
              msg_args = { nhs_number: nhs_num, dob: dob, processed: false }
              _msg_recv_after_patient_creation = create_message(
                created_at: patient_created_at + 1.day, **msg_args
              )
              msg_recv_before_patient_creation = create_message(
                created_at: patient_created_at - 1.day, **msg_args
              )

              results = described_class.new(patient: patient, to: nil).call

              expect(results.to_a).to eq([msg_recv_before_patient_creation])
            end
          end
        end

        context "when to is set to a custom datetime" do
          it "excludes msgs received after that point" do
            freeze_time do
              to = 1.week.from_now
              patient = create(
                :patient,
                nhs_number: nhs_num,
                born_on: dob,
                created_at: 1.year.ago
              )
              msg_args = { nhs_number: nhs_num, dob: dob, processed: false }
              _msg_recv_after = create_message(created_at: to + 2.days, **msg_args)
              msg_recv_before = create_message(created_at: to - 2.days, **msg_args)

              results = described_class.new(patient: patient, to: to).call

              expect(results.to_a).to eq([msg_recv_before])
            end
          end
        end

        context "when to and from are set to custom values" do
          it "excludes msgs received outside of those bounds" do
            freeze_time do
              from = 2.years.ago
              to = 1.year.ago
              patient = create(
                :patient,
                nhs_number: nhs_num,
                born_on: dob,
                created_at: 10.years.ago # NB
              )
              msg_args = { nhs_number: nhs_num, dob: dob, processed: false }
              _msg_recvd_too_early = create_message(created_at: from - 1.week, **msg_args)
              msg_recvd_within_window = create_message(created_at: from + 1.week, **msg_args)
              _msg_recvd_too_late = create_message(created_at: to + 1.week, **msg_args)

              results = described_class.new(patient: patient, from: from, to: to).call

              expect(results.to_a).to eq([msg_recvd_within_window])
            end
          end
        end
      end
    end
  end
end

# describe "matrix of patient <=> feed_message match conditions" do
#   [
#     {
#       comment: "no matching data",
#       patient: { nhs_number: "a", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "b", dob: "111-01-01" },
#       match: false
#     },
#     {
#       comment: "nhs_number match, dob match, but orc_order_status is not CM",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", orc_order_status: "A" },
#       match: false
#     },
#     {
#       comment: "nhs_number match, dob match, but message_type is not ORU",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", message_type: "ADT" },
#       match: false
#     },
#     {
#       comment: "nhs_number match, dob match, but event_type is not R01",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", event_type: "A01" },
#       match: false
#     },
#     {
#       comment: "nhs_number match, dob match",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
#       match: true
#     },
#     {
#       comment: "nhs_number match, dob match, note processed: false",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: false },
#       match: true
#     },
#     {
#       comment: "nhs_number match, dob match, note processed: nil",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: nil },
#       match: true
#     },
#     {
#       comment: "nhs_number match, dob match",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: true },
#       match: false
#     },
#     {
#       comment: "no nhs_number match, dob match",
#       patient: { nhs_number: "1111111111", born_on: "2001-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
#       match: false
#     },
#     {
#       comment: "nhs_number match, dob no match",
#       patient: { nhs_number: "4001540037", born_on: "1111-01-01" },
#       feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
#       match: false
#     },
#     {
#       comment: "no nhs_number match, dob match, local_patient_id match",
#       patient: { nhs_number: "4001540037", born_on: "2001-01-01", local_patient_id: "123" },
#       feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id: "123" },
#       match: true
#     },
#     {
#       comment: "no nhs_number match, dob match, local_patient_id_2 match",
#       patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_2: "222" },
#       feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_2: "222" },
#       match: true
#     },
#     {
#       comment: "no nhs_number match, dob match, local_patient_id_3 match",
#       patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_3: "333" },
#       feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_3: "333" },
#       match: true
#     },
#     {
#       comment: "no nhs_number match, dob match, local_patient_id_4 match",
#       patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_4: "444" },
#       feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_4: "444" },
#       match: true
#     }
#   ].each do |example|
#     it example[:comment] do
#       patient = build(:patient, local_patient_id: nil, **example[:patient])
#       message = create_message(**example[:feed_message])

#       results = described_class.new(patient: patient).call

#       if example[:match]
#         expect(results).to eq([message])
#       else
#         expect(results).to be_empty
#       end
#     end
#   end
# end
