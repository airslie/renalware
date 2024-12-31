Rails.application.routes.draw do
  mount Renalware::Engine => "/"
  resources :dummies, only: :index

  super_admin_constraint = lambda do |request|
    current_user = request.env["warden"].user || Renalware::NullUser.new
    current_user.has_role?(:super_admin)
  end

  constraints super_admin_constraint do
    mount GoodJob::Engine => "good_job"
  end
end
