Renalware::Directory::Engine.routes.draw do
  resources :people, except: [:destroy] do
    collection do
      get :search
    end
  end
end
