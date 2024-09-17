# frozen_string_literal: true

Renalware::Directory::Engine.routes.draw do
  resources :people, except: [:delete] do
    collection do
      get :search
    end
  end
end
