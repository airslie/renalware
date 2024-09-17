# frozen_string_literal: true

module Renalware
  module Research
    class InvestigatorshipsController < BaseController
      helper Renalware::ResearchHelper
      include Pagy::Backend

      def index
        query = InvestigatorshipQuery.new(study: study, options: params[:q])
        pagy, investigatorships = pagy(query.call)
        authorize investigatorships
        render locals: {
          study: study,
          investigatorships: investigatorships,
          query: query.search,
          pagy: pagy
        }
      end

      def new
        investigatorship = build_investigatorship
        authorize investigatorship
        render_new(investigatorship)
      end

      def edit
        render_edit(find_and_authorize_investigatorship)
      end

      def create
        investigatorship = build_investigatorship(investigatorship_params)
        authorize investigatorship
        if investigatorship.save_by(current_user)
          redirect_to research.study_investigatorships_path(study)
        else
          render_new(investigatorship)
        end
      end

      def update
        investigatorship = find_and_authorize_investigatorship
        if investigatorship.update_by(current_user, investigatorship_params)
          redirect_to research.study_investigatorships_path(study)
        else
          render_edit(investigatorship)
        end
      end

      def destroy
        investigatorship = find_and_authorize_investigatorship
        investigatorship.destroy
        redirect_to research.study_investigatorships_path
      end

      private

      def study
        @study ||= Study.find(params[:study_id])
      end

      def find_and_authorize_investigatorship
        study.investigatorships.find(params[:id]).tap do |investigatorship|
          authorize(investigatorship)
        end
      end

      def build_investigatorship(params = {})
        investigatorship_class = study.class.investigatorship_class
        investigatorship_class.new(params).tap do |investigatorship|
          investigatorship.study = study
        end
      end

      def investigatorship_params
        params
          .require(:investigatorship)
          .permit(:user_id, :started_on, :left_on, :manager, document: {})
      end

      def render_new(investigatorship)
        render :new, locals: { investigatorship: investigatorship }
      end

      def render_edit(investigatorship)
        render :edit, locals: { investigatorship: investigatorship }
      end
    end
  end
end
