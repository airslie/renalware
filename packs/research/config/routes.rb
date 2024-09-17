# frozen_string_literal: true

Renalware::Research::Engine.routes.draw do
  resources :studies do
    resources :participations, controller: :participations
    resources :investigatorships, controller: :investigatorships
    resources :memberships, controller: :memberships
    resources :investigatorships, controller: :investigatorships
  end
end
