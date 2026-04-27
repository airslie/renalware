Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  super_admin_constraint = lambda do |request|
    current_user = request.env["warden"].user || Renalware::NullUser.new
    current_user.has_role?(:super_admin)
  end

  constraints super_admin_constraint do
    mount PgHero::Engine, at: "pghero"
    mount GoodJob::Engine => "good_job"
    # For pg_extras work like this we need to set the env var
    # RAILS_PG_EXTRAS_PUBLIC_DASHBOARD=true or
    # set RailsPgExtras.configuration.public_dashboard to true
    # mount RailsPgExtras::Web::Engine, at: "pg_extras"
  end

  mount Renalware::Directory::Engine => "directory", as: :directory
  mount Renalware::Hospitals::Engine => "hospitals", as: :hospitals
  mount Renalware::Reporting::Engine => "reporting", as: :reporting
  mount Renalware::Research::Engine => "research", as: :research
  mount Renalware::Authoring::Engine => "authoring", as: :authoring
  mount Renalware::Help::Engine => "help", as: :help
  mount Renalware::Geography::Engine => "geography", as: :geography
  mount Renalware::RemoteMonitoring::Engine => "remote_monitoring", as: :remote_monitoring

  scope module: :renalware do
    root to: "dashboard/dashboards#show"

    draw :accesses
    draw :admin
    draw :admissions
    draw :api
    draw :clinical
    draw :clinics
    draw :deaths
    draw :dietetics
    draw :drugs
    draw :events
    draw :feeds
    draw :hd
    draw :letters
    draw :low_clearance
    draw :medications
    draw :messaging
    draw :modalities
    draw :pathology
    draw :patients
    draw :pd
    draw :problems
    draw :renal
    draw :system
    draw :transplants
    draw :ukrdc
    draw :users
    draw :virology

    # Last
    draw :fallbacks

    resources :protouis
  end
end
