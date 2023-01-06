# frozen_string_literal: true

resources :users, only: :index, controller: "users/users"
resources :user_groups, controller: "users/groups"
