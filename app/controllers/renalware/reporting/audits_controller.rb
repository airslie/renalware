# frozen_string_literal: true

module Renalware
  module Reporting
    class AuditsController < BaseController
      include PresenterHelper

      def index
        authorize Audit, :index?
        render locals: { audits: present(Audit.enabled, AuditPresenter) }
      end

      def show
        authorize audit
        respond_to do |format|
          format.html { render locals: { audit: audit } }
          format.json { render json: FetchAuditJson.call(audit.view_name) }
        end
      end

      def edit
        authorize audit
        render_edit
      end

      def update
        authorize audit
        if audit.update(audit_params)
          redirect_to reporting_audits_path, notice: success_msg_for("audit")
        else
          render_edit
        end
      end

      private

      def audit
        @audit ||= Audit.find(params[:id])
      end

      # Takes an array (rows) of arrays (cells) and replaces any nil elements
      # with an empty string so JS data tables does not baulk with 'nil undefined' error.
      def replace_nils_with_empty_string(values)
        values.map { |row| row.map { |cell| cell || "" } }
      end

      def render_edit
        render :edit, locals: {
          audit: audit,
          available_data_sources: Renalware::Reporting::Audit.available_audit_materialized_views
        }
      end

      def audit_params
        params.require(:reporting_audit)
              .permit(
                :name,
                :description,
                :view_name,
                :display_configuration,
                :refresh_schedule
              )
      end
    end
  end
end
