require "collection_presenter"

module Renalware
  module HD
    # PrescriptionAdministration witnesses
    class WitnessesController < BaseController
      # GET HTML
      def edit
        form = WitnessForm.new(
          prescription_administration_id: administration.id,
          user_id: administration.witnessed_by_id
        )
        render_edit(form)
      end

      # PATCH JS
      def update
        form = WitnessForm.new(
          form_params.merge(prescription_administration_id: administration.id)
        )

        administration.skip_administrator_validation = true
        administration.skip_witness_validation = true if form.update_user_only
        if update_administration_from(form)
          # will render update.js
        else
          render_edit(form) # re-display dialog with errors
        end
      end

      private

      def update_administration_from(form)
        return unless form.valid?

        administration.witnessed_by_id = form.user_id
        administration.witnessed_by_password = form.password
        unless form.update_user_only
          administration.witness_authorised = true
        end
        administration.save_by(current_user)
      end

      def administration
        @administration ||= PrescriptionAdministration
          .find(params[:prescription_administration_id])
          .tap { |administration| authorize administration }
      end

      def render_edit(form)
        render :edit, locals: { form: form, administration: administration }, layout: false
      end

      def form_params
        params.require(:form).permit(:user_id, :password, :update_user_only)
      end
    end
  end
end
