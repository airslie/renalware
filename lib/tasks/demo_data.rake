require_relative "../../app/models/concerns/renalware/broadcasting"

namespace :demo_data do
  task generate_test_letters: :environment do
    return if Rails.env.production?

    Renalware::GenerateTestLetters.new(ENV.fetch("pages", nil)).call
  end
end

module Renalware
  class GenerateTestLetters
    include Renalware::Broadcasting
    attr_reader :pages

    def initialize(pages = 1)
      @pages = pages.to_i
    end

    def call
      patient = Letters.cast_patient(Patient.find_by(local_patient_id: "Z100001"))
      clinics_patient = Renalware::Clinics.cast_patient(patient)

      users = User.limit(3).to_a

      letter_body = ""

      pages.times do
        letter_body += <<-TEXT
          Cras justo odio, dapibus ac facilisis in, egestas eget quam. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Nulla vitae elit libero, a pharetra augue.
          Cras justo odio, dapibus ac facilisis in, egestas eget quam. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Nulla vitae elit libero, a pharetra augue.
        TEXT
      end
      letter_body += <<-TEXT
        Yours sincerely
      TEXT

      10.times do
        letter = Letters::Letter::PendingReview.create!(
          patient: patient,
          pathology_timestamp: 1.day.ago,
          event: clinics_patient.clinic_visits.first,
          clinical: true,
          topic: Renalware::Letters::Topic.last,
          main_recipient_attributes: {
            person_role: "patient"
          },
          salutation: "Dear Mr Rabbit",
          body: letter_body,
          letterhead: Renalware::Letters::Letterhead.last,
          author: users.sample,
          by: users.sample
        )
        Renalware::Letters::ApproveLetter
          .build(letter)
          .broadcasting_to_configured_subscribers
          .call(by: users.sample)
      end
    end
  end
end
