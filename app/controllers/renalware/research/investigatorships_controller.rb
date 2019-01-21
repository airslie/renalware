# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class InvestigatorshipsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = InvestigatorshipQuery.new(study: study, options: params[:q])
        investigatorships = query.call.page(page).per(per_page)
        authorize investigatorships
        render locals: {
          study: study,
          investigatorships: investigatorships,
          query: query.search
        }
      end

      def new
        investigatorship = study.investigatorships.build
        authorize investigatorship
        render_new(investigatorship)
      end

      def create
        investigatorship = build_investigatorship
        authorize investigatorship
        if investigatorship.save_by(current_user)
          redirect_to research_study_investigatorships_path(study)
        else
          render_new(investigatorship)
        end
      end

      def edit
        render_edit(find_and_authorize_investigatorship)
      end

      def update
        investigatorship = find_and_authorize_investigatorship
        if investigatorship.save_by(current_user)
          redirect_to research_study_investigatorships_path(study)
        else
          render_edit(investigatorship)
        end
      end

      def destroy
        investigatorship = find_and_authorize_investigatorship
        investigatorship.destroy
        redirect_to research_study_investigatorships_path
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

      def build_investigatorship
        class_factory.investigatorship.new(investigatorship_params).tap do |investigatorship|
          investigatorship.study = study
        end
      end

      def class_factory
        ClassFactory.new(namespace: study.namespace)
      end

      def investigatorship_params
        params
          .require(:research_study_investigatorship)
          .permit(:user_id, :hospital_centre_id)
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
