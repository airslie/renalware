describe Renalware::Letters::Delivery::Email::PracticeListener do
  include LettersSpecHelper

  it "emails the approved letter to the patient's practice" do
    patient = instance_double(Renalware::Letters::Patient, confidentiality_restricted?: false)
    letter = instance_double(Renalware::Letters::Letter, patient:)
    allow(Renalware::Letters::Delivery::Email::EmailLetterToPractice).to receive(:call)

    described_class.new.letter_approved(letter)

    expect(Renalware::Letters::Delivery::Email::EmailLetterToPractice)
      .to have_received(:call).with(letter)
  end

  it "does not queue practice email for a confidentiality-restricted patient" do
    ActiveJob::Base.queue_adapter = :test
    allow(Renalware.config).to receive(:allow_external_mail).and_return(true)
    letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
      practice_email: "practice@example.com"
    )
    letter.patient.update_columns(confidentiality: "restricted")

    expect { described_class.new.letter_approved(letter) }
      .not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
    expect(letter.recipients.find(&:primary_care_physician?).reload.emailed_at).to be_nil
  end
end
