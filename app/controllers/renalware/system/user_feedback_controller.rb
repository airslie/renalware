module Renalware
  module System
    class UserFeedbackController < BaseController
      include Pagy::Backend

      def index
        search = UserFeedback
          .includes(:author)
          .order(created_at: :desc)
          .ransack(search_params)

        pagy, feedback_msgs = pagy(search.result)
        authorize feedback_msgs
        render locals: { feedback_msgs: feedback_msgs, search: search, pagy: pagy }
      end

      def new
        feedback = UserFeedback.new
        authorize feedback
        render_new(feedback)
      end

      def edit
        feedback = UserFeedback.find(params[:id])
        authorize feedback
        render locals: { feedback: feedback }
      end

      def create
        feedback = UserFeedback.new(user_feedback_params)
        feedback.author = current_user
        authorize feedback

        if feedback.save
          redirect_to root_url, notice: "Feedback registered, thank you"
        else
          render_new(feedback)
        end
      end

      def update
        feedback = UserFeedback.find(params[:id])
        authorize feedback
        feedback.update!(user_feedback_admin_params)
        redirect_to system_user_feedback_index_path, notice: "Updated"
      end

      private

      def search_params
        hash = params[:q] || {}
        hash[:s] ||= "created_at desc"
        hash
      end

      def render_new(feedback)
        render :new, locals: { feedback: feedback }
      end

      def user_feedback_params
        params.require(:feedback).permit(:comment, :category)
      end

      def user_feedback_admin_params
        params.require(:feedback).permit(:acknowledged, :admin_notes)
      end
    end
  end
end
