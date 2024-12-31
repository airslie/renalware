module Renalware
  class Users::GroupsController < BaseController
    def index
      groups = Users::Group.ordered
      authorize groups
      render locals: { groups: groups }
    end

    def new
      render_new(Users::Group.new)
    end

    def edit
      render_edit(find_and_authorise_group)
    end

    def create
      group = Users::Group.new(group_params)
      authorize group
      if group.save_by(current_user)
        redirect_to user_groups_path, notice: success_msg_for("user group")
      else
        render_new group
      end
    end

    def update
      group = find_and_authorise_group
      if group.update_by(current_user, group_params)
        redirect_to user_groups_path, notice: success_msg_for("user group")
      else
        render_edit group
      end
    end

    private

    def render_new(group)
      authorize group
      render :new, locals: { group: group }
    end

    def render_edit(group)
      render :edit, locals: { group: group }
    end

    def group_params
      params.require(:group).permit(:name, :description, :letter_electronic_ccs, user_ids: [])
    end

    def find_and_authorise_group
      Users::Group.includes(:users).find(params[:id]).tap { |group| authorize(group) }
    end
  end
end
