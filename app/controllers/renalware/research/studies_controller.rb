# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class StudiesController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = Study.ordered.ransack(params[:q])
        studies = query.result.page(page).per(per_page)
        authorize studies
        render locals: { studies: studies, query: query }
      end

      def show
        study = find_and_authorize_study
        render locals: { study: study }
      end

      def new
        study = Study.new
        authorize study
        render_new(study)
      end

      def create
        study = Study.new(study_params)
        authorize study
        if study.save_by(current_user)
          redirect_to research_studies_path, notice: success_msg_for("clinical study")
        else
          render_new(study)
        end
      end

      def edit
        study = find_and_authorize_study
        render_edit(study)
      end

      def update
        study = find_and_authorize_study
        if study.update_by(current_user, study_params)
          redirect_to research_study_path(study), notice: success_msg_for("clinical study")
        else
          render_edit(study)
        end
      end

      def destroy
        study = find_and_authorize_study
        study.destroy!
        redirect_to research_studies_path, notice: success_msg_for("clinical study")
      end

      private

      def find_and_authorize_study
        Study.find(params[:id]).tap { |study| authorize study }
      end

      def render_new(study)
        render :new, locals: { study: study }
      end

      def render_edit(study)
        render :edit, locals: { study: study }
      end

      def study_params
        params
          .require(:study)
          .permit(
            :code, :description, :leader, :notes, :started_on, :terminated_on,
            :application_url, document: {}
          )
      end
    end
  end
end
