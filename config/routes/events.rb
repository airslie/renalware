resources :patients, only: [] do
  resources :events, except: :show, controller: "events/events"
  constraints(format: /(pdf)/) do
    resources :events, only: :show, controller: "events/events"
  end

  resources :swabs,
            only: %i(new create edit update),
            controller: "events/swabs",
            defaults: { slug: :swabs }

  resources :investigations,
            only: %i(new create edit update destroy),
            controller: "events/investigations",
            defaults: { slug: :investigations }

  # Here we could enable new event by any other slug
  # eg patient_new_specific_event(slug: "transplant_biopsies")
  # get "events/:slug/new",
  #     to: "events/events#new",
  #     as: :new_specific_event
  # or we could hardwire routes as we do for swabs.
  get "events/:slug/new",
      to: "events/events#new",
      as: :new_specific_event
end

namespace :events do
  resources :types, except: :show do
    resources :subtypes
  end
  constraints(named_filter: /all/) do
    get(
      "list/:named_filter",
      to: "lists#show",
      as: :filtered_list,
      defaults: { named_filter: "all" }
    )
  end
end
