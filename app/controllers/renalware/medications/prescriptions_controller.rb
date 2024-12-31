module Renalware
  module Medications
    class PrescriptionsController < BaseController
      include PresenterHelper
      include Concerns::ReturnTo
      include Renalware::Concerns::PdfRenderable

      def index
        authorize Prescription, :index?

        presenter = PrescriptionIndexPresenter.new(patient: patient, params: params)

        respond_to do |format|
          format.html do
            render locals: { presenter: presenter }
          end

          format.pdf do
            filename = "#{patient.family_name}_#{patient.hospital_identifier&.id}" \
                       "_medications_#{I18n.l(Time.zone.today)}".upcase

            render_with_wicked_pdf(
              default_pdf_options.merge(
                pdf: filename,
                print_media_type: true,
                locals: { title: pdf_title, presenter: presenter }
              )
            )
          end
        end
      end

      def new # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
        param_attrs = params[:medications_prescription].present? ? prescription_params : {}
        prescription = patient.prescriptions.build
        authorize prescription

        prescription.assign_attributes(param_attrs)
        prescription.treatable_type ||= params[:treatable_type] || "Renalware::Patient"
        prescription.treatable_id ||= params[:treatable_id] || patient.id
        prescription.prescribed_on ||= Date.current
        prescription.provider ||= Provider.codes.find { |code| code == :gp }
        prescription.termination || prescription.build_termination

        render_new(prescription)
      end

      def edit
        prescription = patient.prescriptions.find(params[:id])
        authorize prescription

        if prescription.trade_family_id
          prescription.drug_id_and_trade_family_id = [
            prescription.drug_id, PrescriptionFormPresenter::SEPARATOR, prescription.trade_family_id
          ].join
        else
          prescription.drug_id_and_trade_family_id = prescription.drug_id
        end
        prescription.termination || prescription.build_termination
        render_edit(prescription)
      end

      def create
        prescription = patient.prescriptions.new(prescription_params)
        authorize prescription

        termination = prescription.termination
        termination.terminated_on_set_by_user = true if termination&.terminated_on_changed?

        allow_other_domains_to_alter_prescription_before_save(prescription)

        if prescription.save
          redirect_to return_to_param || patient_prescriptions_path(patient)
        else
          render_new prescription
        end
      end

      # NB: allow_other_domains_to_alter_prescription_before_save is called in RevisePrescription
      def update
        prescription = patient.prescriptions.find(params[:id])
        authorize prescription

        termination = prescription.termination
        termination.terminated_on_set_by_user = true if termination&.terminated_on_changed?

        if RevisePrescription.new(prescription, current_user).call(prescription_params)
          redirect_to return_to_param || patient_prescriptions_path(patient)
        else
          render_edit(prescription)
        end
      end

      private

      def pdf_title
        title = "Medication List"

        if hd_only?
          title = "Medications to be given on HD"
          # TODO: move this bit
          params[:q] ||= {}
          params[:q][:administer_on_hd_eq] = true
        end
        title
      end

      def hd_only?
        params[:hd_only] == "true"
      end

      def render_edit(prescription)
        render(
          :edit,
          locals: local_params(prescription).merge(
            update_url: patient_prescription_path(patient, prescription),
            search_url: new_patient_prescription_path(patient)
          )
        )
      end

      def render_new(prescription)
        render(
          :new,
          locals: local_params(prescription).merge(
            update_url: patient_prescriptions_path(patient),
            search_url: new_patient_prescription_path(patient)
          )
        )
      end

      def local_params(prescription)
        {
          patient: patient,
          prescription: prescription,
          presenter: PrescriptionFormPresenter.new(
            prescription: prescription,
            selected_drug_id: prescription.drug_id,
            selected_trade_family_id: prescription.trade_family_id,
            selected_form_id: prescription.form_id
          )
        }
      end

      def prescription_params
        permitted = params
          .require(:medications_prescription)
          .permit(prescription_attributes)

        if permitted[:drug_id_and_trade_family_id].present?
          permitted[:drug_id], permitted[:trade_family_id] =
            permitted[:drug_id_and_trade_family_id].split(PrescriptionFormPresenter::SEPARATOR)
        end

        permitted.to_h
          .deep_merge(by: current_user, termination_attributes: { by: current_user })
      end

      def prescription_attributes
        [
          :drug_id, :dose_amount, :dose_unit, :unit_of_measure_id, :medication_route_id,
          :frequency, :frequency_comment,
          :administer_on_hd, :stat, :notes, :prescribed_on, :provider, :form_id,
          :drug_id_and_trade_family_id, :treatable_type, :treatable_id,
          :last_delivery_date, :next_delivery_date, { termination_attributes: :terminated_on }
        ]
      end

      # TODO: HD reference here not great. Broadcast to listeners via Wisper?
      def allow_other_domains_to_alter_prescription_before_save(prescription)
        HD::AssignFuturePrescriptionTermination.call(
          prescription: prescription,
          by: current_user
        )
      end
    end
  end
end
