# frozen_string_literal: true

Renalware::Engine.routes.draw do
  root to: "dashboard/dashboards#show"

  mount Renalware::Directory::Engine => "directory", as: :directory
  mount Renalware::Hospitals::Engine => "hospitals", as: :hospitals
  mount Renalware::Reporting::Engine => "reporting", as: :reporting
  mount Renalware::Research::Engine => "research", as: :research
  mount Renalware::Authoring::Engine => "authoring", as: :authoring
  mount Renalware::RemoteMonitoring::Engine => "remote_monitoring", as: :remote_monitoring

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
