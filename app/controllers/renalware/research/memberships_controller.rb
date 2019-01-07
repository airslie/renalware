# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class MembershipsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = MembershipsQuery.new(study: study, options: params[:q])
        memberships = query.call.page(page).per(per_page)
        authorize memberships
        render locals: { study: study, memberships: memberships, query: query.search }
      end

      def new
        membership = study.memberships.build
        authorize membership
        render_new(membership)
      end

      def create
        membership = study.memberships.new(membership_params)
        authorize membership
        if membership.save_by(current_user)
          redirect_to research_study_memberships_path(study)
        else
          render_new(membership)
        end
      end

      def edit
        render_edit(find_and_authorize_membership)
      end

      def update
        membership = find_and_authorize_membership
        if membership.save_by(current_user)
          redirect_to research_study_memberships_path(study)
        else
          render_edit(membership)
        end
      end

      def destroy
        membership = find_and_authorize_membership
        membership.destroy
        redirect_to research_study_memberships_path
      end

      private

      def study
        @study ||= Study.find(params[:study_id])
      end

      def find_and_authorize_membership
        study.memberships.find(params[:id]).tap { |membership| authorize(membership) }
      end

      def membership_params
        params
          .require(:research_study_membership)
          .permit(:user_id, :hospital_centre_id)
      end

      def render_new(membership)
        render :new, locals: { membership: membership }
      end

      def render_edit(membership)
        render :edit, locals: { membership: membership }
      end
    end
  end
end
