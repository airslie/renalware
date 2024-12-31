module Renalware
  module Pathology
    class CodeGroupsController < BaseController
      def index
        groups = CodeGroup.order(:name)
        authorize groups, :index?
        render locals: { groups: groups }
      end

      def show
        render locals: { group: find_authorize_group }
      end

      def edit
        render locals: { group: find_authorize_group }
      end

      def update
        group = find_authorize_group
        if group.update_by(current_user, code_group_params)
          redirect_to pathology_code_groups_path, notice: "Group saved"
        else
          render :edit, locals: { group: group }
        end
      end

      private

      def find_authorize_group
        CodeGroup.find(params[:id]).tap { |group| authorize group }
      end

      def code_group_params
        params
          .require(:code_group)
          .permit(:description)
      end
    end
  end
end
