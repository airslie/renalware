# frozen_string_literal: true

namespace :drugs do
  resources :patient_group_directions
  resources :dmd_matches, only: [:index, :new, :create]

  resources :drugs, except: :show do
    collection do
      scope format: true, constraints: { format: :json } do
        get :selected_drugs
        get :prescribable, as: :prescribable
      end
    end
  end
end
