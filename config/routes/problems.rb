resources :patients, only: [] do
  resource :comorbidities, controller: "problems/comorbidities"
  resources :problems, controller: "problems/problems", except: [:new] do
    get :search, on: :collection
    post :sort, on: :collection
    resources :notes, controller: "problems/notes"
  end
end
