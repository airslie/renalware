resources :patients, only: [] do
  resources :admissions, only: [:index], controller: "admissions/patient_admissions"
end

namespace :admissions do
  resources :requests, except: :show do
    post :sort, on: :collection
  end
  resources :consults, except: :show
  resources :admissions, except: :show
end
