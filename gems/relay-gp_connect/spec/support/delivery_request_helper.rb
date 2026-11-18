module DeliveryRequestHelper
  # A complete, fixed DeliveryRequest built from plain values: no models, no database.
  # rubocop:disable-next Metrics/MethodLength
  def plain_delivery_request
    Relay::GPConnect::DeliveryRequest.new(
      patient: Relay::GPConnect::DeliveryRequest::Patient.new(
        uuid: "11111111-1111-1111-1111-111111111111",
        nhs_number: "9999999999",
        born_on: Date.new(1970, 1, 2),
        given_name: "Patricia",
        family_name: "Jones",
        title: "Ms",
        display_name: "JONES, Patricia (Ms)",
        sex_code: "M",
        telephone: "01234 567890",
        email: "patricia@example.com",
        restricted: false,
        address: nil,
        local_patient_ids: ["KCH12345"]
      ),
      author: Relay::GPConnect::DeliveryRequest::Author.new(
        uuid: "22222222-2222-2222-2222-222222222222",
        given_name: "Jane",
        family_name: "Doctor",
        professional_position: "Consultant Nephrologist"
      ),
      document: Relay::GPConnect::DeliveryRequest::Document.new(
        uuid: "33333333-3333-3333-3333-333333333333",
        binary_uuid: "55555555-5555-5555-5555-555555555555",
        approved_at: Time.utc(2022, 1, 1, 1, 1, 1),
        pdf_content: "%PDF-1.4 golden",
        type_snomed_code: "371531000",
        type_snomed_title: "Report of clinical encounter",
        composition_title: "Consultation report",
        version: 1
      ),
      routing: Relay::GPConnect::DeliveryRequest::Routing.new(recipient_mailbox_id: nil),
      sender: Relay::GPConnect::DeliveryRequest::Sender.new(
        uuid: "88888888-8888-8888-8888-888888888888",
        itk_uuid: "99999999-9999-9999-9999-999999999999",
        ods_code: "RAJ01",
        name: "Test Hospital",
        phone: "01111 111111",
        email: "org@example.com",
        mailbox_id: "?",
        care_setting_snomed_code: "788003006",
        care_setting_description: "Nephrology service"
      )
    )
  end
end
