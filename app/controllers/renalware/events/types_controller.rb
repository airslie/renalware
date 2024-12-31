module Renalware
  module Events
    class TypesController < BaseController
      def index
        event_types = Type.includes(:category).order(:name).all
        authorize event_types
        deleted_event_types = event_types.with_deleted.where.not(deleted_at: nil)
        render locals: {
          event_types: CollectionPresenter.new(event_types, TypePresenter),
          deleted_event_types: CollectionPresenter.new(deleted_event_types, TypePresenter)
        }
      end

      def new
        event_type = Type.new
        authorize event_type
        render locals: { event_type: event_type }
      end

      def edit
        event_type = load_and_authorize_event_type
        render locals: { event_type: event_type }
      end

      def create
        event_type = Type.new(event_params)
        authorize event_type
        if event_type.save
          redirect_to events_types_path, notice: success_msg_for("event type")
        else
          flash.now[:error] = failed_msg_for("event type")
          render :new, locals: { event_type: event_type }
        end
      end

      def update
        event_type = load_and_authorize_event_type
        if event_type.update(event_params)
          redirect_to events_types_path, notice: success_msg_for("event type")
        else
          flash.now[:error] = failed_msg_for("event type")
          render :edit, locals: { event_type: event_type }
        end
      end

      def destroy
        event_type = load_and_authorize_event_type
        event_type.destroy
        redirect_to events_types_path, notice: success_msg_for("event type")
      end

      private

      def event_params
        params
          .require(:events_type)
          .permit(
            :name,
            :category_id,
            :deleted_at,
            :save_pdf_to_electronic_public_register,
            :external_document_type_code,
            :external_document_type_description,
            :superadmin_can_always_change,
            :author_change_window_hours,
            :admin_change_window_hours
          )
      end

      def load_and_authorize_event_type
        event_type = Type.find(params[:id])
        authorize event_type
        event_type
      end
    end
  end
end
