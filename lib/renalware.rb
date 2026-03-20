require "rubygems"
require "tailwindcss-rails" if Rails.env.local?
require "debug" if ENV.fetch("RAILS_ENV", nil) == "development"
require "renalware/pack_engines"
Renalware::PackEngines.load!

module Renalware
  VERSION = "2.4.5.6".freeze

  # Keep table names unchanged (do not prefix with renalware_).
  def self.table_name_prefix = nil

  # Preserve engine-era param keys and route keys for namespaced models, e.g.
  # `Renalware::Virology::Profile` => `virology_profile`.
  def self.use_relative_model_naming?
    true
  end
end
