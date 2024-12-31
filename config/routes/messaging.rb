namespace :messaging do
  namespace :internal do
    resources :messages, only: %i(new create index) do
      resources :receipts, only: [] do
        patch :mark_as_read, on: :member
      end
    end
    scope :messages do
      get "inbox", to: "receipts#unread", as: :inbox
      get "read", to: "receipts#read", as: :read_receipts
      get "sent", to: "receipts#sent", as: :sent_messages
    end
  end
end

resources :patients, only: [] do
  namespace :messaging do
    namespace :internal do
      resources :messages, only: :index
    end
  end
end
