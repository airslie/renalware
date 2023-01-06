# frozen_string_literal: true

resources :patients, only: [] do
  namespace :dietetics do
    resource :mdm, only: :show, controller: "mdm"
  end
end
