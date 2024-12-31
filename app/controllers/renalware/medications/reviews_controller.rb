module Renalware
  module Medications
    class ReviewsController < Events::EventsController
      def create
        authorize Review, :create?
        review = patient.medication_reviews.create!(
          by: current_user,
          date_time: Time.zone.now,
          event_type: event_type_for_review_events
        )
        render :create, locals: { patient: patient, review: review }
      end

      private

      def event_type_for_review_events
        Events::Type.find_by!(event_class_name: Review.name)
      end
    end
  end
end
