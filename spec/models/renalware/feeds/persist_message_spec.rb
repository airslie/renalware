module Renalware::Feeds
  describe PersistMessage do
    subject(:service) { described_class.new }

    describe "#call" do
      let(:hl7_message) {
        instance_double(
          HL7Message,
          time: Time.zone.parse("2023-01-01 00:00:01"),
          type: "::message type code::",
          message_type: "ADT",
          event_type: "A31",
          orc_order_status: "CM",
          orc_filler_order_number: "123",
          header_id: "::header id::",
          patient_dob: Date.parse("20010101"),
          to_hl7: "::message body::",
          patient_identification: double(
            internal_id: "123",
            hospital_identifiers: {
              "HOSP1" => "1111",
              "HOSP2" => "2222",
              "HOSP3" => "3333",
              "HOSP4" => "4444",
              "HOSP5" => "5555"
            },
            nhs_number: "1"
          )
        )
      }

      it "persists the payload" do
        expect { service.call(hl7_message) }.to change(Message, :count).by(1)

        expect(Message.last).to have_attributes(
          orc_order_status: "CM",
          header_id: "::header id::",
          message_type: "ADT",
          event_type: "A31",
          orc_filler_order_number: "123",
          dob: Date.parse("20010101"),
          sent_at: Time.zone.parse("2023-01-01 00:00:01")
        )
      end

      describe "patient identifiers => local_patient_ids mapping" do
        it "splits out the patient identifiers into local_patient_id* columns" do
          allow(Renalware.config)
            .to receive(:patient_hospital_identifiers)
            .and_return(
              HOSP1: :local_patient_id,
              HOSP2: :local_patient_id_2,
              HOSP3: :local_patient_id_3,
              HOSP4: :local_patient_id_4,
              HOSP5: :local_patient_id_5
            )

          feed_message = service.call(hl7_message)

          expect(feed_message.reload).to have_attributes(
            nhs_number: "1",
            local_patient_id: "1111",
            local_patient_id_2: "2222",
            local_patient_id_3: "3333",
            local_patient_id_4: "4444",
            local_patient_id_5: "5555"
          )
        end

        # |                    |  HL7   | config | Persisted
        # |                    |  Msg   | map    |
        # |--------------------|--------|--------|---------
        # | local_patient_id   |  HOSP1 | HOSP1  |  Y
        # | local_patient_id_2 |  HOSPX | HOSP2  |  N
        # | local_patient_id_3 |  HOSP3 | HOSPY  |  N
        # | local_patient_id_4 |  HOSP4 | HOSP4  |  Y
        # | local_patient_id_5 |  nil   | HOSP5  |  N
        it "silently fails to update unmatched data" do
          hl7_message = instance_double(
            HL7Message,
            time: Time.zone.parse("2023-01-01 00:00:01"),
            type: "::message type code::",
            message_type: "ADT",
            event_type: "A31",
            orc_order_status: nil,
            patient_dob: Date.parse("20010101"),
            header_id: "::header id::",
            orc_filler_order_number: "123",
            to_hl7: "::message body::",
            patient_identification: double(
              internal_id: "123",
              hospital_identifiers: {
                "HOSP1" => "1111",
                "HOSP2" => "2222",
                "HOSPY" => "3333",
                "HOSP4" => "4444"
              },
              nhs_number: "1"
            )
          )

          allow(Renalware.config)
            .to receive(:patient_hospital_identifiers)
            .and_return(
              HOSP1: :local_patient_id,
              HOSPX: :local_patient_id_2,
              HOSP3: :local_patient_id_3,
              HOSP4: :local_patient_id_4
            )

          feed_message = service.call(hl7_message)

          expect(feed_message).to have_attributes(
            sent_at: Time.zone.parse("2023-01-01 00:00:01"),
            nhs_number: "1",
            local_patient_id: "1111",
            local_patient_id_2: nil,
            local_patient_id_3: nil,
            local_patient_id_4: "4444",
            local_patient_id_5: nil
          )
        end

        it "does not fall over if hospital_identifiers is empty" do
          hl7_message = instance_double(
            HL7Message,
            time: Time.zone.parse("2023-01-01 00:00:01"),
            type: "::message type code::",
            message_type: "ADT",
            event_type: "A31",
            orc_order_status: nil,
            orc_filler_order_number: "123",
            patient_dob: Date.parse("20010101"),
            header_id: "::header id::",
            to_hl7: "::message body::",
            patient_identification: double(
              internal_id: "123",
              hospital_identifiers: {},
              nhs_number: "1"
            )
          )

          expect { service.call(hl7_message) }.to change(Message, :count).by(1)
        end
      end

      it "generates an MD5 hash of the payload which should be unique and therefore " \
         "prevent duplicates" do
        service.call(hl7_message)

        expect(Message.first.body_hash).to eq(Digest::MD5.hexdigest("::message body::"))
      end

      it "causes a database unique constraint violation if the same message body is saved twice" do
        service.call(hl7_message)

        expect {
          service.call(hl7_message)
        }.to raise_error(
          Renalware::Feeds::DuplicateMessageError,
          "header_id=::header id::, body_hash=#{Digest::MD5.hexdigest('::message body::')}"
        )
      end
    end
  end
end
