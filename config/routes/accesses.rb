resources :patients, only: [] do
  namespace :accesses do
    resource :dashboard, only: :show
    resources :assessments, except: %i(index destroy)
    resources :procedures, except: %i(index destroy)
    resources :profiles, except: %i(index destroy)
    resources :plans, except: %i(index destroy)
    resources :needling_assessments, except: %i(index update show)
  end
end
