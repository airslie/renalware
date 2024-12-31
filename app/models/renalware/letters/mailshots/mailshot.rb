module Renalware
  module Letters
    module Mailshots
      class Mailshot < ApplicationRecord
        include Accountable
        # This maps to a PG enum called background_job_status
        enum :status, {
          queued: "queued",
          processing: "processing",
          success: "success",
          failure: "failure"
        }

        belongs_to :author, class_name: "User"
        belongs_to :letterhead
        has_many :items, dependent: :destroy
        has_many :letters, through: :items

        validates :description, presence: true
        validates :sql_view_name, presence: true
        validates :body, presence: true
        validates :author, presence: true
        validates :letterhead, presence: true

        # The sql view should ideally only have one column - 'patient_id' because we use this
        # to filter the patients we want.
        def recipient_patients
          @recipient_patients ||= begin
            return Patient.none if sql_view_name.blank?

            Patient
              .where(Arel.sql("id in (select distinct patient_id from #{sql_view_name})"))
              .order(:family_name, :given_name)
          end
        end

        # Called usually by a background job, creates all the letters in the mailshot.
        # The patients to create letters for are defined by the SQL view output.
        # The other data items required for creating the letters are stored in the mailshot
        # object
        def create_letters
          Mailshot.transaction do
            recipient_patients.each do |patient|
              letter = MailshotLetterFactory.new(
                patient: patient,
                current_user: created_by,
                letter_attributes: common_letter_attributes
              ).create
              items.create!(letter: letter)
            end
          end
        end

        # These attributes apply to all letters in the mailshot
        def common_letter_attributes
          @common_letter_attributes ||= begin
            {
              letterhead_id: letterhead_id,
              description: description,
              body: body,
              author_id: author_id,
              main_recipient_attributes: {
                person_role: :patient,
                id: nil,
                addressee_id: nil
              }
            }
          end
        end
      end

      # Factory class responsible for creating a mailshot letter by moving it
      # through its 'state machine' states until it is approved and ready to print.
      # Doing it this ways ensures all pub/sub events, callbacks etc happen in
      # correctly and in order.
      class MailshotLetterFactory
        pattr_initialize [:patient!, :current_user!, :letter_attributes!]
        attr_reader :letter

        def create
          draft
          submit_for_review
          approve
          letter
        end

        def draft
          @letter = LetterFactory
            .new(patient, letter_attributes)
            .with_contacts_as_default_ccs
            .build
          letter.save_by!(current_user)
        end

        def submit_for_review
          letter.submit(by: current_user) # now pending review
          letter.save!
          @letter = Letters::Letter::PendingReview.find(letter.id)
        end

        def approve
          ApproveLetter
            .build(letter)
            .broadcasting_to_configured_subscribers
            .call(by: current_user)
        end
      end
    end
  end
end
