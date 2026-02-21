describe "Mirth HL7 feed processing simulation" do
  def oru_message(
    sent_at: "20240316235859",
    orc_filler_order_number: "12345",
    message_control_id: SecureRandom.uuid.to_s
  )
    Renalware::Feeds::Msg.create!(
      sent_at: Time.zone.parse(sent_at),
      message_control_id:,
      orc_filler_order_number:,
      message_type: "ORU",
      event_type: "R01",
      body: ""
    )
  end

  def adt_message(
    sent_at: "20240316235859"
  )
    Renalware::Feeds::Msg.create!(
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
    message_control_id: SecureRandom.uuid.to_s
  )
    fmt_sent_at = if sent_at.present?
                    "TO_TIMESTAMP('#{sent_at}', 'YYYYMMDDHH24MISS')::timestamp without time zone"
                  else
                    "NULL"
                  end

    ActiveRecord::Base.connection.execute(<<~SQL.squish)
      select * from renalware.feed_msgs_upsert_from_mirth(
        _sent_at => #{fmt_sent_at},
        _message_type => '#{message_type}',
        _event_type => '#{event_type}',
        _message_control_id => '#{message_control_id}',
        _nhs_number => '#{nhs_number}',
        _local_patient_id => '#{local_patient_id}',
        _local_patient_id_2 => '#{local_patient_id_2}',
        _local_patient_id_3 => '#{local_patient_id_3}',
        _local_patient_id_4 => '4',
        _local_patient_id_5 => '5',
        _dob => '2000-01-01',
        _orc_filler_order_number => '#{orc_filler_order_number}',
        _orc_order_status => 'CM',
        _body => '#{body}'
      )
    SQL
  end
  # rubocop:enable Metrics/MethodLength, Metrics/ParameterLists

  context "when ORU^R01" do
    describe "argument validation" do
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

    it "inserts a row into feed_msgs and a corresponding row into feed_msg_queue, " \
       "indicating the message is ready to be processed by a background job" do
      result = simulate_mirth_creating_oru_message

      msg_id, msg_queue_id = result.values[0]
      expect(msg_id).to be > 0
      expect(msg_queue_id).to be > 0

      expect(Renalware::Feeds::Msg.count).to eq(1)
      expect(Renalware::Feeds::Msg.first.id).to eq(msg_id)

      expect(Renalware::Feeds::MsgQueue.count).to eq(1)
      expect(Renalware::Feeds::MsgQueue.first.id).to eq(msg_queue_id)
    end
  end

  context "when ADT^R01" do
    it "inserts a row into feed_msgs and a corresponding row into feed_msg_queue, " \
       "indicating the message is ready to be processed by a background job" do
      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: nil
      )
      expect(Renalware::Feeds::Msg.count).to eq(1)
      expect(Renalware::Feeds::MsgQueue.count).to eq(1)

      simulate_mirth_creating_adt_message(
        sent_at: "20010101111111",
        body: "original_body",
        orc_filler_order_number: nil
      )

      expect(Renalware::Feeds::Msg.count).to eq(2)
      expect(Renalware::Feeds::MsgQueue.count).to eq(2)
    end
  end
end
