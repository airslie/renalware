Renalware::Authoring::Engine.routes.draw do
  resources :snippets, except: :show do
    resources :snippet_clones, only: :create, as: :clones
    resources :snippet_invocations, only: %i(index create), as: :invocations
  end
end
