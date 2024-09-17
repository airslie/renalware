# frozen_string_literal: true

Renalware::Hospitals::Engine.routes.draw do
  resources :centres, only: :index do
    resources :departments
  end
  resources :units, except: :show do
    resources :wards
    scope format: true, constraints: { format: :json } do
      resources :wards, only: :index
    end
  end
end
