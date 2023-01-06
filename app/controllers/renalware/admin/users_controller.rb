# frozen_string_literal: true

module Renalware
  class Admin::UsersController < BaseController
    include Renalware::Concerns::Pageable

    def index
      query = params.fetch(:q, {})
      query[:s] ||= "family_name"
      search = User
        .includes(:roles, :hospital_centre)
        .where.not(username: :systemuser)
        .ransack(query)
      users = search.result(distinct: true).page(page).per(per_page)
      authorize users
      render locals: { users: users, user_search: search }
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
      user_params.merge(roles: roles)
    end

    def user_params
      params
        .require(:user)
        .permit(
          :approved, :unexpire, :telephone,
          :consultant, :hidden, :prescriber,
          :banned, :notes, :access_unlock,
          :hospital_centre_id,
          role_ids: []
        )
    end

    def role_ids
      (user_params[:role_ids] || []).reject(&:blank?)
    end
  end
end
