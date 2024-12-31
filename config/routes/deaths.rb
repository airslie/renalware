namespace :deaths do
  resources :locations, except: :show
end
