# rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
module LettersSpecHelper
  def simple_stubbed_letter(patient)
    topic = build(:letter_topic, snomed_document_type: build(:snomed_document_type))
    instance_double(Renalware::Letters::Letter, patient: patient, topic: topic)
  end

  def build_letter(to:, patient:, state: :draft, **args)
    args = args.compact # remove nil values eg if author is nil
    trait = :"#{state}_letter"
    letter = build(trait, **args)
    letter.patient = patient

    letter.patient.primary_care_physician ||= build(:letter_primary_care_physician)

    attributes = build_main_recipient_attributes(to)
    letter.main_recipient = build(:letter_recipient, :main, attributes)

    # We shouldn't have to do this but for some reason in RSpec tests if the second test in a suite
    # creates a letter it can end up with type of nil - something in Rails is not setting it.
    # Hence this unpleasant hack:
    letter.type ||= letter.class.sti_name

    letter
  end

  def create_letter(**)
    letter = build_letter(**)
    letter.save!
    letter
  end

  def build_main_recipient_attributes(to)
    case to
    when :patient
      { person_role: "patient" }
    when :primary_care_physician
      { person_role: "primary_care_physician" }
    else
      address_attributes = attributes_for(:address)
      {
        person_role: "contact",
        address_attributes: address_attributes,
        addressee: build(:directory_person, address_attributes: address_attributes)
      }
    end
  end

  def create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
    user: nil,
    body: "test",
    page_count: 1,
    practice_email: nil,
    patient: nil,
    clinical: false,
    author: nil,
    gp_send_status: nil
  )
    user ||= create(:user)

    practice = create(
      :practice,
      email: practice_email
    )
    primary_care_physician = create(
      :letter_primary_care_physician,
      address: build(:address, street_1: "::gp_address::")
    )

    patient ||= create(
      :letter_patient,
      primary_care_physician: primary_care_physician,
      practice: practice,
      given_name: "John",
      family_name: "Smith",
      by: user
    )

    patient.current_address.update(
      street_1: "A",
      street_2: "B",
      street_3: "C",
      town: "D",
      county: "E",
      postcode: "F"
    )

    person = create(
      :directory_person,
      by: user,
      given_name: "Jane",
      family_name: "Contact",
      address: build(
        :address,
        street_1: "1",
        street_2: "2",
        street_3: "3",
        town: "4",
        county: "5",
        postcode: "6"
      )
    )
    contact = create(
      :letter_contact,
      patient: patient,
      person: person
    )

    letter = create_letter(
      to: :patient,
      patient: patient,
      state: :pending_review,
      page_count: page_count,
      body: body,
      clinical: clinical,
      author: author
    )

    create(
      :letter_recipient,
      :cc,
      person_role: "contact",
      letter: letter,
      addressee: contact
    )
    Renalware::Letters::ApproveLetter.new(letter).call(by: user)
    letter = Renalware::Letters::Letter.find(letter.id)

    # This is a bit of a hack: as ApproveLetter will set the gp_send_status to pending,
    # but we might want it to be something else for testing purposes, update the status here
    letter.update_column(:gp_send_status, gp_send_status) if gp_send_status.present?
    letter
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/ParameterLists
