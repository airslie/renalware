resources :patients, only: [] do
  namespace :virology do
    resource :dashboard, only: :show, path: "/dashboard"
    resource :profile, except: :destroy

    resources :vaccinations,
              only: %i(new create edit update),
              defaults: { slug: :vaccinations }
  end
end

namespace :virology do
  resources :vaccination_types do
    patch :move, on: :member
  end
end
