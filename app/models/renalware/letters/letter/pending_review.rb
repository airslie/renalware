# frozen_string_literal: true

module Renalware
  module Letters
    class Letter::PendingReview < Letter
      def self.policy_class = PendingReviewLetterPolicy

      def revise(params)
        params = LetterParamsProcessor.new(patient).call(params)
        self.attributes = params
      end

      def reject(by:)
        becomes!(Draft).tap { |letter| letter.by = by }
      end

      def sign(by:)
        build_signature(user: by, signed_at: Time.current)
        self.approved_by = by
        self.approved_at = Time.current
        self.by = by
        self
      end

      def generate_archive(by:, presenter: default_presenter)
        becomes!(Approved).tap do |letter|
          letter.by = by
          # Note there is no need to set letter_id: id here but there is an
          # intermittent issue where (oddly) build_archive fails because letter_id not
          # present, so in attempt to fix this we are setting it here explicitly.
          # Using self.id rather than letter.id in case the becomes! has lost the id
          # for some reason. Also moved presenter.content to a new line so we can more easily see
          # if that is causing the error as it does a lot of processing to build the letter.
          # TODO: investigate
          letter.build_archive(
            by: by,
            content: presenter.content,
            pdf_content: nil, # presenter.pdf_content, was using prawn
            letter_id: id
          )
        end
      end

      private

      def default_presenter
        LetterPresenterFactory.new(self)
      end
    end
  end
end
