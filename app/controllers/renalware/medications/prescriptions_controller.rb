# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Renalware
  module Medications
    class PrescriptionsController < BaseController
      include PrescriptionsHelper
      include PresenterHelper

      def index
        authorize Prescription, :index?
        @treatable = treatable_class.find(treatable_id)
        respond_to do |format|
          format.html { render_index }
          format.js { render_index }
          format.pdf do
            render_prescriptions_list_to_hand_to_patient(hd_only: params[:hd_only] == "true")
          end
        end
      end

      def new
        @treatable = treatable_class.find(treatable_id)
        prescription = build_new_prescription_for(@treatable)
        authorize prescription
        render_form(prescription, url: patient_prescriptions_path(patient, @treatable))
      end

      def create
        @treatable = treatable_class.find(treatable_id)

        prescription = patient.prescriptions.new(
          prescription_params.merge(treatable: @treatable)
        )
        authorize prescription

        if prescription.save
          render_index
        else
          render_form(prescription, url: patient_prescriptions_path(patient, @treatable))
        end
      end

      def edit
        prescription = patient.prescriptions.find(params[:id])
        authorize prescription
        @treatable = prescription.treatable

        render_form(prescription, url: patient_prescription_path(patient, prescription))
      end

      def update
        prescription = patient.prescriptions.find(params[:id])
        authorize prescription
        @treatable = prescription.treatable

        updated = RevisePrescription.new(prescription).call(prescription_params)

        if updated
          render_index
        else
          render_form(prescription, url: patient_prescription_path(patient, prescription))
        end
      end

      private

      def build_new_prescription_for(treatable)
        gp_provider_code = Provider.codes.find { |code| code == :gp }
        prescription = Prescription.new(treatable: treatable, provider: gp_provider_code)
        prescription.build_termination
        prescription.prescribed_on = Date.current
        prescription
      end

      def render_index
        render :index, locals: locals
      end

      # rubocop:disable Layout/LineLength, Metrics/MethodLength
      def render_prescriptions_list_to_hand_to_patient(hd_only:)
        title = "Medication List"

        if hd_only
          title = "Medications to be given on HD"
          params[:q] ||= {}
          params[:q][:administer_on_hd_eq] = true
        end

        render_with_wicked_pdf(
          pdf_options.merge(
            pdf: pdf_filename,
            disposition: "inline",
            print_media_type: true,
            locals: {
              title: title,
              patient: patient,
              current_prescriptions: present(current_prescriptions, PrescriptionPresenter),
              recently_stopped_prescriptions: present(recently_stopped_prescriptions, PrescriptionPresenter),
              recently_changed_prescriptions: present(recently_changed_current_prescriptions, PrescriptionPresenter)
            }
          )
        )
      end
      # rubocop:enable Layout/LineLength, Metrics/MethodLength

      def pdf_filename
        "#{patient.family_name}_#{patient.hospital_identifier&.id}" \
        "_medications_#{I18n.l(Time.zone.today)}".upcase
      end

      def pdf_options
        {
          page_size: "A4",
          layout: "renalware/layouts/letter",
          show_as_html: params.key?(:debug),
          footer: {
            font_size: 8,
            right: "page [page] of [topage]"
          }
        }
      end

      def locals
        {
          patient: patient,
          treatable: present(@treatable, TreatablePresenter),
          current_search: current_prescriptions_query.search,
          current_prescriptions: present(current_prescriptions, PrescriptionPresenter),
          historical_prescriptions_search: historical_prescriptions_query.search,
          historical_prescriptions: present(historical_prescriptions, PrescriptionPresenter),
          drug_types: find_drug_types
        }
      end

      def render_form(prescription, url:)
        render "form", locals: {
          patient: patient,
          treatable: @treatable,
          prescription: prescription,
          provider_codes: present(Provider.codes, ProviderCodePresenter),
          medication_routes: present(MedicationRoute.all, RouteFormPresenter),
          url: url
        }
      end

      def treatable_class
        @treatable_class ||= treatable_type.singularize.classify.constantize
      end

      def prescription_params
        params
          .require(:medications_prescription)
          .permit(prescription_attributes)
          .to_h
          .deep_merge(by: current_user, termination_attributes: { by: current_user })
      end

      def prescription_attributes
        [
          :drug_id, :dose_amount, :dose_unit, :medication_route_id, :frequency,
          :administer_on_hd, :route_description, :notes, :prescribed_on, :provider,
          :last_delivery_date, :next_delivery_date, { termination_attributes: :terminated_on }
        ]
      end

      def treatable_type
        params.fetch(:treatable_type)
      end

      def treatable_id
        params.fetch(:treatable_id)
      end

      def current_prescriptions_query
        @current_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions.current,
            search_params: params[:q]
          )
      end

      def current_prescriptions
        call_query(current_prescriptions_query)
      end

      def historical_prescriptions_query
        @historical_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions,
            search_params: params[:q]
          )
      end

      # Prescriptions created or with dosage changed in the last 14 days.
      # Because we terminated a prescription if the dosage changes, and create a new one,
      # we just need to search for prescriptions created in the last 14 days.
      def recently_changed_current_prescriptions
        @recently_changed_current_prescriptions ||= begin
          current_prescriptions_query
            .call
            .prescribed_between(from: 14.days.ago, to: ::Time.zone.now)
        end
      end

      # Find prescriptions terminated within 14 days.
      # Note we do not include those prescriptions which might have just had a dose change
      # so they were implicitly terminated and re-created. We only want ones which were explicitly
      # terminated.
      def recently_stopped_prescriptions
        @recently_stopped_prescriptions ||= begin
          historical_prescriptions_query.call
            .terminated
            .terminated_between(from: 14.days.ago, to: ::Time.zone.now)
            .where.not(drug_id: current_prescriptions.map(&:drug_id))
        end
      end

      def call_query(query)
        query
          .call
          .with_created_by
          .with_medication_route
          .with_drugs
          .with_termination
      end

      def historical_prescriptions
        call_query(historical_prescriptions_query)
      end

      def find_drug_types
        Drugs::Type.all
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
