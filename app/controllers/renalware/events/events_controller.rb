# frozen_string_literal: true

module Renalware
  module Events
    class EventsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend
      include Renalware::Concerns::PdfRenderable

      def index
        events_query = EventQuery.new(patient: patient, query: query_params)
        pagy, events = pagy(events_query.call)
        authorize events
        events = EventsPresenter.new(patient, events)

        render locals: {
          events: events,
          query: events_query.search,
          pagy: pagy
        }
      end

      # Render a PDF of the event
      def show
        event = load_and_authorize_event_for_edit_or_update
        respond_to do |format|
          format.pdf do
            pdf = EventPdf.new(EventPdfPresenter.new(event))
            send_data pdf.render, type: "application/pdf", disposition: "inline"
          end
        end
      end

      # HTML GET when rendering the new form
      # JS GET after user selects event type, prompting us to return event-specific form fields
      def new
        save_path_to_return_to
        render_new(build_new_event)
      end

      def edit
        unless turbo_frame_request?
          session[:events_edit_back_url] = request.referer
        end
        render_edit(load_and_authorize_event_for_edit_or_update)
      end

      def create
        event = new_event_for_patient(event_params)

        if CreateEvent.call(event: event, by: current_user)
          redirect_to return_url, notice: success_msg_for("event")
        else
          flash.now[:error] = failed_msg_for("event")
          render_new(event)
        end
      end

      def update
        event = load_and_authorize_event_for_edit_or_update

        if UpdateEvent.call(event: event, params: event_params, by: current_user)
          redirect_to(
            session.delete(:events_edit_back_url) || patient_events_path,
            notice: success_msg_for("event")
          )
        else
          flash.now[:error] = failed_msg_for("event type")
          render_edit(event)
        end
      end

      def destroy
        load_and_authorize_event_for_edit_or_update.destroy!
        flash[:notice] = "Event deleted"
        redirect_to request.referer
      end

      protected

      def render_new(event)
        render :new, locals: {
          patient: patient,
          event: event,
          event_types: event_types
        }
      end

      def render_edit(event)
        render :edit, locals: {
          patient: patient,
          event: event,
          event_types: []
        }
      end

      def save_path_to_return_to
        return unless request.format == :html

        session[:return_to] ||= request.path
      end

      def return_url
        @return_url ||= begin
          path = session.delete(:return_to)
          path = nil if path == new_patient_event_path(patient)
          path || patient_events_path(patient)
        end
      end
      helper_method :return_url

      def load_and_authorize_event_for_edit_or_update
        event = Event.for_patient(patient).find(params[:id])
        authorize event
        event.disable_selection_of_event_type = true
        event
      end

      private

      def disable_selection_of_event_type?
        event_type_slug.present? && event_type.present?
      end

      def build_new_event
        event = new_event_for_patient
        event.date_time = Time.zone.now
        event.event_type = event_type
        # disable_selection_of_event_type is a virtual attribute
        event.disable_selection_of_event_type = disable_selection_of_event_type?
        event
      end

      def event_class
        event_type.event_class_name.constantize
      end

      def event_type
        return Events::Type.find(event_type_id) if event_type_id.present?
        return Events::Type.find_by!(slug: event_type_slug) if event_type_slug.present?

        Events::Type.new
      end

      def event_type_id
        @event_type_id ||= begin
          if params[:events_event]
            event_params[:event_type_id]
          else
            params[:event_type_id]
          end
        end
      end

      def event_type_slug
        params[:slug]
      end

      def event_params
        params
          .require(:events_event)
          .permit(
            :event_type_id,
            :date_time,
            :description,
            :notes,
            :disable_selection_of_event_type,
            :subtype_id,
            document: {}
          )
      end

      def new_event_for_patient(params = {})
        event = event_class.new
        event.attributes = params
        # Need to set disable_selection_of_event_type explicitly rather than relying on the value
        # in the params which is a string eg "false" which actually evaluates to true!
        # i.e. (!!"false" == true)
        event.disable_selection_of_event_type = disable_selection_of_event_type?
        event.patient = patient
        authorize event
        event
      end

      # Returns an array of objects defining each category, with that category's types within it.
      # rubocop:disable Layout/LineLength
      def event_types
        Events::Category.order(:position).map do |category|
          types = category.types.visible.order(:name).map do |event_type|
            [
              event_type.name,
              event_type.id,
              {
                data: {
                  source: new_patient_event_path(patient, event_type_id: event_type.id, format: :js),
                  save_pdf_to_epr: event_type.save_pdf_to_electronic_public_register?
                }
              }
            ]
          end
          OpenStruct.new(name: category.name, id: category.id, types: types)
        end
      end
      # rubocop:enable Layout/LineLength

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
