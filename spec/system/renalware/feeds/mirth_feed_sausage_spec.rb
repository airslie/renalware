# frozen_string_literal: true

describe "Mirth HL7 feed processing simulation" do
  def oru_message(
    sent_at: "20240316235859",
    orc_filler_order_number: "12345",
    header_id: 1
  )
    Renalware::Feeds::Sausage.create!(
      sent_at: Time.zone.parse(sent_at),
      header_id: header_id,
      orc_filler_order_number: orc_filler_order_number,
      message_type: "ORU",
      event_type: "R01",
      body: ""
    )
  end

  def adt_message(
    sent_at: "20240316235859"
  )
    Renalware::Feeds::Sausage.create!(
      sent_at: Time.zone.parse(sent_at),
      orc_filler_order_number: nil,
      message_type: "ADT",
      event_type: "A31",
      body: ""
    )
  end

  def simulate_mirth_creating_oru_message(**)
    simulate_mirth_creating_message(
      message_type: "ORU",
      event_type: "R01",
      orc_filler_order_number: "12345",
      **
    )
  end

  def simulate_mirth_creating_adt_message(**)
    simulate_mirth_creating_message(
      message_type: "ADT",
      event_type: "A38",
      **
    )
  end

  # Call the SQL fn that Mirth would call
  # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
  def simulate_mirth_creating_message(
    message_type:,
    event_type:,
    sent_at: "20240316235859",
    orc_filler_order_number: nil,
    body: "body",
    nhs_number: "9999999999",
    local_patient_id: "local1",
    local_patient_id_2: "local2",
    local_patient_id_3: "local3",
    header_id: 1
  )
    fmt_sent_at = if sent_at.present?
                    "TO_TIMESTAMP('#{sent_at}', 'YYYYMMDDHH24MISS')::timestamp without time zone"
                  else
                    "NULL"
                  end

    ActiveRecord::Base.connection.execute(<<-SQL.squish)
      select * from renalware.feed_sausages_upsert_from_mirth(
        _sent_at => #{fmt_sent_at},
        _message_type => '#{message_type}',
        _event_type => '#{event_type}',
        _orc_filler_order_number => '#{orc_filler_order_number}',
        _orc_order_status => 'CM',
        _header_id => '#{header_id}',
        _body => '#{body}',
        _nhs_number => '#{nhs_number}',
        _local_patient_id => '#{local_patient_id}',
        _local_patient_id_2 => '#{local_patient_id_2}',
        _local_patient_id_3 => '#{local_patient_id_3}',
        _local_patient_id_4 => '4',
        _local_patient_id_5 => '5',
        _dob => '2000-01-01'
      )
    SQL
  end
  # rubocop:enable Metrics/MethodLength, Metrics/ParameterLists

  context "when ORU^R01" do
    describe "argument validation" do
      it "fails if _orc_filler_order_number param is blank" do
        expect {
          simulate_mirth_creating_oru_message(orc_filler_order_number: "")
        }.to raise_error(
          ActiveRecord::StatementInvalid,
          /PG::RaiseException: ERROR:  orc_filler_order_number cannot be blank/
        )
      end

      it "fails if _orc_filler_order_number param is null" do
        expect {
          simulate_mirth_creating_oru_message(orc_filler_order_number: nil)
        }.to raise_error(
          ActiveRecord::StatementInvalid,
          /PG::RaiseException: ERROR:  orc_filler_order_number cannot be blank/
        )
      end

      it "fails if _sent_at is null" do
        expect {
          simulate_mirth_creating_oru_message(sent_at: nil)
        }.to raise_error(ActiveRecord::NotNullViolation, /_sent_at/)
      end

      it "fails if _message_type is not valid" do
        expect {
          simulate_mirth_creating_oru_message(message_type: nil)
        }.to raise_error(ActiveRecord::StatementInvalid, /_message_type/)
      end

      it "fails if _event_type is not valid" do
        expect {
          simulate_mirth_creating_oru_message(event_type: nil)
        }.to raise_error(ActiveRecord::StatementInvalid, /_event_type/)
      end
    end

    context "when the ORC Filler Order Number does not yet exist in RW" do
      it "inserts a new row" do
        result = simulate_mirth_creating_oru_message

        sausage_id, sausage_queue_id = result.values[0]
        expect(sausage_id).to be > 0
        expect(sausage_queue_id).to be > 0

        expect(Renalware::Feeds::Sausage.count).to eq(1)
        expect(Renalware::Feeds::Sausage.first.id).to eq(sausage_id)

        expect(Renalware::Feeds::SausageQueue.count).to eq(1)
        expect(Renalware::Feeds::SausageQueue.first.id).to eq(sausage_queue_id)
      end
    end

    context "when a msg with a ORC Filler Order Number already exists" do
      it "updates the existing row and adds the msg to the queue if sent_at and header id are " \
         "greater" do
        sausage = oru_message(
          orc_filler_order_number: "12335",
          sent_at: "20010101111111",
          header_id: 10
        )

        expect(Renalware::Feeds::Sausage.count).to eq(1)
        expect(Renalware::Feeds::SausageQueue.count).to eq(0)
        expect(sausage.created_at - sausage.updated_at).to eq(0.0) # ie not changes yet
        expect(sausage.version).to eq(1)
        expect(sausage.header_id).to eq("10")

        result = simulate_mirth_creating_oru_message(
          orc_filler_order_number: "12335",
          sent_at: "20010101222222",
          header_id: "11"
        )

        sausage_id, sausage_queue_id = result.values[0]
        expect(sausage_id).to eq(sausage.id)
        expect(sausage_queue_id).to be > 0

        expect(Renalware::Feeds::Sausage.count).to eq(1)
        expect(Renalware::Feeds::SausageQueue.count).to eq(1)
        expect(Renalware::Feeds::SausageQueue.first.id).to eq(sausage_queue_id)

        sausage.reload
        expect(sausage.created_at - sausage.updated_at).to be > 0.0 # ie updated
        expect(sausage.version).to eq(2)
      end
    end

    context "when a msg with ORC Filler Order Number exists and is already in the queue" do
      context "when the sent_at in the new msg is newer than the one stored" \
              "and the header_id integer is a higher number" do
        it "updates the existing row and adds a new entry in the queue" do
          # First create the message and the queue entry ie the indication to 'please pick me up'
          simulate_mirth_creating_oru_message(
            orc_filler_order_number: "12335",
            sent_at: "20010101111111",
            header_id: 10
          )

          # Sanity check
          expect(Renalware::Feeds::Sausage.count).to eq(1)
          expect(Renalware::Feeds::SausageQueue.count).to eq(1)

          # Wind back the timestamps on both rows because were are in a txn where
          # the value of current_timestamp in postgres is frozen, so we can't test that our
          # updated_at col has changed - also any update to a model will touch updated_at
          # so beware unless we use update_column(s), updating the updated_at col directly
          # will only ever set it to current_timestamp as it tries to capture the model touch...
          sausage = Renalware::Feeds::Sausage.last
          queued = Renalware::Feeds::SausageQueue.last
          sausage.update_columns(created_at: 1.day.ago, updated_at: 1.day.ago)
          queued.update_columns(created_at: 1.day.ago, updated_at: 1.day.ago)

          # Simulate mirth adding a new version of message ie same orc_filler_order_number
          # with a newer date, so it will keep the row and update the columns
          result = simulate_mirth_creating_oru_message(
            orc_filler_order_number: "12335",
            sent_at: "20010101222222",
            body: "content of new msg",
            nhs_number: "1111111111",
            local_patient_id: "new local 1",
            local_patient_id_2: "new local 2",
            local_patient_id_3: "new local 3",
            header_id: "11"
          )

          sausage.reload
          queued.reload

          # We should not have created new msg and queue rows, but should have updated extant ones
          expect(Renalware::Feeds::Sausage.count).to eq(1)
          expect(Renalware::Feeds::SausageQueue.count).to eq(2)

          sausage_id, sausage_queue_id = result.values[0]
          expect(sausage_id).to eq(sausage.id) # same sausage
          expect(sausage_queue_id).not_to eq(queued.id) # ie a new queue item added

          expect(sausage.updated_at - sausage.created_at).to be > 0.0 # ie updated_at is newer
          expect(sausage).to have_attributes(
            sent_at: Time.zone.parse("20010101222222"),
            body: "content of new msg",
            nhs_number: "1111111111",
            local_patient_id: "new local 1",
            local_patient_id_2: "new local 2",
            header_id: "11",
            local_patient_id_3: "new local 3"
          )
        end
      end

      context "when the sent_at in the new msg is older than the one stored" do
        it "does not update the stores feed msg or the queued item" do
          older_datetime = "20010101111111"
          newer_datetime = "20010101222222"

          # First create the message and the queue entry ie the indication to 'please pick me up'
          simulate_mirth_creating_oru_message(
            orc_filler_order_number: "12335",
            sent_at: newer_datetime,
            body: "original_body"
          )

          # Simulate mirth adding a new version of message ie same orc_filler_order_number
          # with a newer date, so it will keep the row and update the columns
          result = simulate_mirth_creating_oru_message(
            orc_filler_order_number: "12335",
            sent_at: older_datetime,
            body: "content of new msg",
            nhs_number: "1111111111",
            local_patient_id: "new local 1",
            local_patient_id_2: "new local 2",
            local_patient_id_3: "new local 3",
            header_id: "aaa"
          )

          # We should not have created new msg and queue rows, and we should not have updated the
          # existing ones either
          expect(Renalware::Feeds::Sausage.count).to eq(1)
          expect(Renalware::Feeds::SausageQueue.count).to eq(1)

          # No ids will have been returned from the fn
          sausage_id, sausage_queue_id = result.values[0]
          expect(sausage_id).to be_nil
          expect(sausage_queue_id).to be_nil

          sausage = Renalware::Feeds::Sausage.last

          # Check original msg data has not been changed
          expect(sausage).to have_attributes(
            sent_at: Time.zone.parse(newer_datetime),
            body: "original_body"
          )
        end
      end
    end
  end

  context "when ADT^R01" do
    it "always stores new messages even if there are duplicate NULL orc_filler_order_numbers" do
      # it does not update existing messages because we only do that where there is a unique
      # orc_filler_order_number, and ADT messages do not have a orc_filler_order_number

      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: nil
      )
      expect(Renalware::Feeds::Sausage.count).to eq(1)
      expect(Renalware::Feeds::SausageQueue.count).to eq(1)

      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: nil
      )

      expect(Renalware::Feeds::Sausage.count).to eq(2)
      expect(Renalware::Feeds::SausageQueue.count).to eq(2)
    end

    it "always stores new messages even if there are duplicate '' orc_filler_order_numbers" do
      # it does not update existing messages because we only do that where there is a unique
      # orc_filler_order_number, and ADT messages do not have a orc_filler_order_number

      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: ""
      )
      expect(Renalware::Feeds::Sausage.count).to eq(1)
      expect(Renalware::Feeds::SausageQueue.count).to eq(1)

      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: ""
      )

      expect(Renalware::Feeds::Sausage.count).to eq(2)
      expect(Renalware::Feeds::SausageQueue.count).to eq(2)
    end
  end
end
