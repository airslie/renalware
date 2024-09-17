# frozen_string_literal: true

module Renalware
  module Letters
    module Transports::Mesh
      class TestcaseInvocationsController < BaseController
        include Broadcasting

        # rubocop:disable Metrics/MethodLength, Rails/I18nLocaleTexts
        def create
          authorize Transmission, :create?
          redirect_back fallback_location: letters_transports_mesh_help_path,
                        notice: "Working"

          %w(invrep 10001 10002 10003 10004 10005 10007 10008 10009 10010
             20001 20002 20003 20004 20005 20006 20007 20008 20009 20010
             20011 20012 20013 20014 20015 30001 30002 30003 30004 IB001
             IB002 IB003 IB004).each do |code|
            patient = create_patient_using(code)
            letter = create_letter_for(patient)
            transmission = Transmission.create!(letter: letter, comment: "ITK3 test case #{code}")
            transmission.reload
            SendMessageJob.perform_now(transmission)
          end
        end
        # rubocop:enable Metrics/MethodLength, Rails/I18nLocaleTexts

        private

        def create_patient_using(code)
          patient = Renalware::Patient.find(1)
          patient.update!(given_name: code, by: current_user)
          patient
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create_letter_for(patient)
          patient = patient.becomes(Letters::Patient)
          draft_letter = LetterFactory.new(
            patient,
            clinical: true,
            author: current_user,
            letterhead: Letterhead.first,
            topic: Topic.first,
            description: "sss",
            by: current_user
          ).build
          draft_letter.save!
          draft_letter = patient.letters.draft.find(draft_letter.id)
          letter_pending_review = draft_letter.submit(by: current_user)
          letter_pending_review.save!
          letter_pending_review = patient.letters.pending_review.find(letter_pending_review.id)

          ApproveLetter
            .new(letter_pending_review)
            .call(by: current_user)

          patient.letters.approved.find(draft_letter.id)
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
