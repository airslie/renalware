module Renalware
  module Users
    class UsersController < BaseController
      include Pagy::Backend
      use_layout :simple

      def index
        query = params.fetch(:q, {})
        query[:s] ||= "family_name"
        search = User
          .includes(:roles)
          .where.not(username: %i(rwdev systemuser))
          .where(hidden: false)
          .ransack(query)
        pagy, users = pagy(search.result(distinct: true))
        authorize users
        render locals: { users: users, pagy: pagy, user_search: search }
      end
    end
  end
end
