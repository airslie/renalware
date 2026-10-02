module Renalware
  module Pathology
    class CodeGroupsController < BaseController
      def index
        groups = CodeGroup.includes(:memberships).order(:name)
        authorize groups, :index?
        render locals: { groups: groups }
      end

      def show
        render locals: { group: find_authorize_group }
      end

      def new
        group = CodeGroup.new(subgroup_titles: [""], subgroup_colours: [nil])
        authorize group
        render locals: { group: group }
      end

      def edit
        render locals: { group: find_authorize_group }
      end

      def create
        group = CodeGroup.new(context_specific: false)
        authorize group
        save(group, :new)
      end

      def update
        save(find_authorize_group, :edit)
      end

      def draft
        group = params[:id] ? find_authorize_group : CodeGroup.new(context_specific: false)
        authorize group
        CodeGroupDraft.new(group, attributes: code_group_params, command: command_params).apply
        render group.persisted? ? :edit : :new, locals: { group: group },
                                                status: :unprocessable_content
      end

      def destroy
        group = find_authorize_group
        if group.deletable?
          group.destroy!
          redirect_to pathology_code_groups_path, notice: "Code group deleted"
        else
          redirect_to edit_pathology_code_group_path(group),
                      alert: "This code group cannot be deleted"
        end
      end

      private

      def save(group, template)
        group.by = current_user
        CodeGroupDraft.new(group, attributes: code_group_params).apply
        group.memberships.each { |membership| membership.by = current_user }
        if group.save(context: :design)
          redirect_to pathology_code_groups_path, notice: "Code group saved"
        else
          render template, locals: { group: group }, status: :unprocessable_content
        end
      end

      def find_authorize_group
        CodeGroup.find(params[:id]).tap { |group| authorize group }
      end

      def code_group_params
        permitted = [
          :title,
          :description,
          { subgroup_titles: [], subgroup_colours: [] },
          { memberships_attributes: %i(id observation_description_id subgroup
                                       position_within_subgroup _destroy) }
        ]
        permitted.unshift(:name) unless params[:id]
        params.fetch(:code_group, {}).permit(*permitted)
      end

      def command_params
        params
          .permit(:remove_result, :observation_description_id, :subgroup)
          .merge(name: params[:command])
      end
    end
  end
end
