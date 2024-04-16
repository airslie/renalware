# frozen_string_literal: true

Renalware::Engine.routes.draw do
  root to: "dashboard/dashboards#show"
  mount Renalware::Reporting::Engine => "reporting", as: :reporting
  draw :accesses
  draw :admin
  draw :admissions
  draw :api
  draw :clinical
  draw :clinics
  draw :dietetics
  draw :deaths
  draw :directory
  draw :drugs
  draw :events
  draw :feeds
  draw :hd
  draw :hospitals
  draw :letters
  draw :low_clearance
  draw :medications
  draw :messaging
  draw :modalities
  draw :pathology
  draw :patients
  draw :problems
  draw :pd
  draw :renal
  # draw :reporting
  draw :research
  draw :snippets
  draw :system
  draw :transplants
  draw :users
  draw :ukrdc
  draw :virology

  # Last
  draw :fallbacks

  resources :protouis
end
