# frozen_string_literal: true

module Renalware
  module Patients
    class BookmarksController < BaseController
      include Pagy::Backend

      before_action :load_patient, only: :create

      # Display the user's bookmarks
      def index
        search = BookmarksQuery.new(
          default_relation: Patients.cast_user(current_user).bookmarks,
          params: params[:q]
        ).search

        pagy, bookmarks = pagy(search.result)
        authorize bookmarks
        render locals: { bookmarks: bookmarks, search: search, pagy: pagy }
      end

      # idempotent
      def create
        Bookmark.find_or_create_by!(user: user, patient: patient) do |bookmark|
          bookmark.assign_attributes(bookmark_params)
        end
        redirect_back(fallback_location: patient_path(patient),
                      notice: success_msg_for("bookmark"))
      end

      # idempotent
      def destroy
        bookmark = user.bookmarks.find_by(id: params[:id])
        patient = bookmark&.patient
        if bookmark.present?
          authorize bookmark
          bookmark.destroy
        else
          skip_authorization
        end
        fallback_location = patient.presence || root_path
        redirect_back(fallback_location: patient_path(fallback_location),
                      notice: success_msg_for("bookmark"))
      end

      def edit
        bookmark = user.bookmarks.find_by(id: params[:id])
        authorize bookmark
        render locals: { bookmark: bookmark }
      end

      def update
        bookmark = user.bookmarks.find_by(id: params[:id])
        authorize bookmark
        if bookmark.update(bookmark_params)
          redirect_to bookmarks_path, notice: success_msg_for("Bookmark")
        else
          flash.now[:error] = failed_msg_for("Bookmark")
          render :edit, locals: { bookmark: bookmark }
        end
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def bookmark_params
        params.require(:patients_bookmark).permit(:notes, :urgent, :tags)
      end

      def search_params
        hash = params[:q] || {}
        hash[:s] ||= "created_at desc"
        hash
      end
    end
  end
end
