namespace :feeds do
  resources :hl7_test_messages
  resources :queued_outgoing_documents, constraints: { format: :json }, defaults: { format: :json }
  resources :outgoing_documents, only: :index
  resources :logs, only: :index
  resources :replay_requests, only: :index do
    resources :message_replays, only: :index
  end
end
