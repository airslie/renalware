# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module HD
    class SlotRequestsController < BaseController
      include Pagy::Backend

      def index
        render_collection(relation: SlotRequest.current, historical: false)
      end

      # Get/Collection
      def historical
        render_collection(
          relation: SlotRequest.historical.includes(:deletion_reason),
          historical: true
        )
      end

      def new
        slot_request = SlotRequest.new
        authorize slot_request
        patient = params.key?(:patient) && Patient.find_by(secure_id: params[:patient])
        slot_request.patient = patient
        render_new(slot_request)
      end

      def create
        slot_request = SlotRequest.new(slot_request_params)
        authorize slot_request

        if slot_request.save_by(current_user)
          if redirect_to_patient_on_success?
            patient = Patient.find(slot_request_params[:patient_id].to_i)
            # Note that if using the data-action="turbo:submit-end->turbo-modal#submitEnd" method
            # then we would instead return `head :no_content, location: url`
            # However we are currently using the approach of handling "turbo:frame-missing"
            # in application.js  - redirecting if the 'modal' tuboframe not found in the rendered
            # page. See https://turbo.hotwired.dev/handbook/frames#breaking-out-from-a-frame
            # The approach of adding <meta name="turbo-visit-control" content="reload"> also works
            # but rather messy.
            # Both the above approaches cause a double render of the of the target page unfort.
            # Awaiting a better, perhaps built-in, solution in a future Turbo version.
            # Note our modal setup works in tandem with app/components/modal_component
            # and app/javascript/turbo_modal_component. Its an evolving approach because, as I say,
            # Turbo is still working out the best approach. There are suggestions on how to handle
            # breaking out without a double render here https://github.com/hotwired/turbo/issues/257
            # and I have implemented one using data-action="turbo:submit-end->turbo-modal#submitEnd"
            # in ModalComponent and a submitEnd() method in app/javascript/turbo_modal_component
            # and this works fine if we return from this action eg
            #  head :no_content, location: url
            # I have also trued returning a custom redirect TurboStream action but if feels like
            # overkill
            # However for simplicity we are sticking with a global "turbo:frame-missing" handler
            # for now.
            redirect_to patient_clinical_summary_path(patient), notice: "HD slot requested"
          else
            # Note that if using the data-action="turbo:submit-end->turbo-modal#submitEnd" method
            # then we would instead return `head :no_content, location: url`
            redirect_to hd_slot_requests_path, notice: "HD slot requested"
          end
        else
          render_new(slot_request)
        end
      end

      def edit
        slot_request = SlotRequest.find(params[:id])
        authorize slot_request
        render_edit(slot_request)
      end

      def update
        slot_request = SlotRequest.find(params[:id])
        authorize slot_request

        if params.key?("commit") # submit via form
          if slot_request.update_by(current_user, slot_request_params)
            redirect_to hd_slot_requests_path
          else
            render_edit(slot_request)
          end
        else # submit via link_to eg if allocating or marking as 'deleted'
          update_params = slot_request_params.to_h
          make_allocated(update_params) if update_params.key?(:allocated)
          make_deleted(update_params) if update_params.key?(:deletion_reason_id)
          slot_request.update_by(current_user, update_params)
          redirect_to hd_slot_requests_path
        end
      end

      private

      def redirect_to_patient_on_success? = params[:redirect_to_patient_on_success] == "true"

      def make_allocated(update_params)
        update_params[:allocated_at] = Time.zone.now
        update_params.delete(:allocated)
      end

      def make_deleted(update_params)
        update_params[:deleted_at] = Time.zone.now
        update_params[:deletion_reason_id] = update_params[:deletion_reason_id]
      end

      def render_edit(slot_request)
        render(
          :edit,
          locals: {
            slot_request: slot_request,
            urgency_dropdown_options: urgency_dropdown_options,
            redirect_to_patient_on_success: true
          }
        )
      end

      def render_new(slot_request)
        render(
          :new,
          locals: {
            slot_request: slot_request,
            urgency_dropdown_options: urgency_dropdown_options,
            redirect_to_patient_on_success: redirect_to_patient_on_success?
          }
        )
      end

      def render_collection(relation:, historical: false)
        query = default_relation.merge(relation).ransack(ransack_params)
        pagy, slot_requests = pagy(query.result)
        authorize slot_requests
        render locals: {
          pagy: pagy,
          query: query,
          slot_requests: slot_requests,
          historical: historical,
          urgency_dropdown_options: urgency_dropdown_options
        }
      end

      def urgency_dropdown_options
        Renalware::HD::SlotRequest.urgencies.each_key.map do |urgency|
          [
            urgency.to_s.humanize,
            urgency
          ]
        end
      end

      def default_relation
        SlotRequest
          .includes(patient: [current_modality: :description])
          .ordered
      end

      def ransack_params
        query = params.fetch(:q, {})
        query[:s] ||= "created_at desc"
        remove_unchecked_boolean_ransack_filters(query, :inpatient_true)
        remove_unchecked_boolean_ransack_filters(query, :late_presenter_true)
        remove_unchecked_boolean_ransack_filters(query, :suitable_for_twilight_slots_true)
        remove_unchecked_boolean_ransack_filters(query, :external_referral)
        query
      end

      def slot_request_params
        params
          .require(:hd_slot_request)
          .permit(:patient_id, :urgency, :notes, :allocated, :allocated_at,
                  :deletion_reason_id, :deleted_at,
                  :inpatient, :suitable_for_twilight_slots, :late_presenter, :external_referral)
      end

      def remove_unchecked_boolean_ransack_filters(query, condition)
        query.delete(condition) if query[condition] == "0"
      end
    end
  end
end
