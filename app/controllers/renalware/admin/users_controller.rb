# frozen_string_literal: true

module Renalware
  class Admin::UsersController < BaseController
    include Renalware::Concerns::Pageable

    def index
      query = params.fetch(:q, {})
      query[:s] ||= "family_name"
      search = User
        .includes(:roles)
        .where.not(username: :systemuser)
        .ransack(query)
      users = search.result(distinct: true).page(page).per(per_page)
      authorize users
      render locals: { users: users, user_search: search }
    end

    def edit
      load_user
    end

    def update
      load_user

      if update_user.call(update_params)
        redirect_to admin_users_path,
                    notice: t(".success", model_name: "user")
      else
        flash.now[:error] = t(".failed", model_name: "user")
        render :edit
      end
    end

    private

    def load_user
      @user = User.find(params[:id])
      authorize @user
    end

    def update_params
      roles = Array(Role.fetch(role_ids))
      user_params.merge(roles: roles)
    end

    def user_params
      params.require(:user).permit(:approved, :unexpire, :telephone, role_ids: [])
    end

    def role_ids
      (user_params[:role_ids] || []).reject(&:blank?)
    end

    def update_user
      @update_user ||= System::UpdateUser.new(@user)
    end
  end
end
