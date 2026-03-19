require "rubygems"
require "tailwindcss-rails" if Rails.env.local?
require "debug" if ENV.fetch("RAILS_ENV", nil) == "development"

require "renalware/version"
require "renalware/pack_engines"

module Renalware
  # Keep table names unchanged (do not prefix with renalware_).
  def self.table_name_prefix = nil

  # Preserve engine-era param keys and route keys for namespaced models, e.g.
  # `Renalware::Virology::Profile` => `virology_profile`.
  def self.use_relative_model_naming?
    true
  end
end
