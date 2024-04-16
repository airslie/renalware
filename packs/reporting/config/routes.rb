# frozen_string_literal: true

Renalware::Reporting::Engine.routes.draw do
  resources :audits, except: [:destroy, :create, :new]
  resources :view_metadata_refreshments, only: [:create]
  resources :reports, only: [:index, :show] do
    member do
      get :chart
      get :content
      get :chart_raw
    end
  end
end
