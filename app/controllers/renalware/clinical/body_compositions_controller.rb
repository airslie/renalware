require "collection_presenter"

module Renalware
  module Clinical
    class BodyCompositionsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend

      def index
        authorize BodyComposition, :index?
        pagy, body_compositions = pagy(BodyComposition.for_patient(clinical_patient).ordered)

        render locals: {
          patient: clinical_patient,
          body_compositions: body_compositions,
          pagy: pagy
        }
      end

      def show
        body_composition = find_body_composition
        render locals: { patient: clinical_patient, body_composition: body_composition }
      end

      def new
        body_composition = BodyComposition.new(
          patient: clinical_patient,
          assessor: current_user,
          assessed_on: Time.zone.today
        )
        authorize body_composition
        render_new(body_composition)
      end

      def edit
        body_composition = find_body_composition
        render locals: { patient: clinical_patient, body_composition: body_composition }
      end

      def create
        body_composition = build_body_composition
        authorize body_composition
        if body_composition.save
          redirect_to patient_clinical_profile_path(clinical_patient),
                      notice: success_msg_for("body composition")
        else
          flash.now[:error] = failed_msg_for("body composition")
          render_new(body_composition)
        end
      end

      def update
        body_composition = find_body_composition
        authorize body_composition
        if body_composition.update(body_composition_params)
          redirect_to patient_clinical_profile_path(clinical_patient),
                      notice: success_msg_for("body_composition")
        else
          render :edit, locals: { patient: clinical_patient, body_composition: body_composition }
        end
      end

      protected

      def render_new(body_composition)
        render :new, locals: {
          body_composition: body_composition,
          patient: clinical_patient
        }
      end

      def build_body_composition
        BodyComposition.new(
          body_composition_params.to_h.merge!(
            patient: clinical_patient,
            modality_description: clinical_patient.modality_description
          )
        )
      end

      def body_composition_params
        params
          .require(:clinical_body_composition)
          .permit(attributes)
          .merge(by: current_user)
      end

      def find_body_composition
        Clinical::BodyComposition
          .for_patient(clinical_patient)
          .find(params[:id]).tap { |bc| authorize(bc) }
      end

      def attributes
        [
          :assessed_on, :overhydration, :volume_of_distribution, :total_body_water,
          :extracellular_water, :intracellular_water, :lean_tissue_index,
          :fat_tissue_index, :lean_tissue_mass, :fat_tissue_mass, :adipose_tissue_mass,
          :body_cell_mass, :quality_of_reading, :assessor_id, :notes, :weight, :pre_post_hd
        ]
      end
    end
  end
end
