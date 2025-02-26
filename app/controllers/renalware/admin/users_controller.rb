module Renalware
  class Admin::UsersController < BaseController
    include Pagy::Backend

    def index
      query = params.fetch(:q, {})
      query[:s] ||= "family_name"
      search = User
        .includes(:roles, :hospital_centre)
        .where.not(username: :systemuser)
        .ransack(query)
      pagy, users = pagy(search.result(distinct: true))
      authorize users
      render locals: { users: users, user_search: search, pagy: pagy }
    end

    def edit
      render locals: { user: find_and_authorize_user }
    end

    def update
      user = find_and_authorize_user
      if System::UpdateUser.new(user).call(update_params)
        redirect_to admin_users_path,
                    notice: success_msg_for("user")
      else
        flash.now[:error] = failed_msg_for("user")
        render :edit, locals: { user: user }
      end
    end

    private

    def find_and_authorize_user
      User.find(params[:id]).tap { |user_| authorize user_ }
    end

    def update_params
      roles = Array(Role.fetch(role_ids))
      user_params
        .merge(
          roles: roles,
          approved: ("true" if params[:approve].present?)
        )
    end

    def user_params
      params
        .require(:user)
        .permit(
          :approved, :unexpire, :telephone,
          :consultant, :hidden, :prescriber,
          :banned, :notes, :access_unlock,
          :hospital_centre_id, :nursing_experience_level,
          role_ids: []
        )
    end

    def role_ids
      (user_params[:role_ids] || []).compact_blank
    end
  end
end
