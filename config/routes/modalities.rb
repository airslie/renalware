resources :patients, only: [] do
  resources :modalities, controller: "modalities/modalities"
end

namespace :modalities do
  resources :descriptions, except: [:show]
end
