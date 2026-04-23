require "rubygems"
require "active_support/string_inquirer"
require "tailwindcss-rails" if Rails.env.local?
require "debug" if ENV.fetch("RAILS_ENV", nil) == "development"
require "renalware/pack_engines"
Renalware::PackEngines.load!

module Renalware
  VERSION = "2.5.0".freeze

  # Keep table names unchanged (do not prefix with renalware_).
  def self.table_name_prefix = nil

  # Preserve engine-era param keys and route keys for namespaced models, e.g.
  # `Renalware::Virology::Profile` => `virology_profile`.
  def self.use_relative_model_naming?
    true
  end

  class << self
    def stage
      ActiveSupport::StringInquirer.new(
        ENV.fetch("RENALWARE_STAGE", "").to_s.strip.downcase
      )
    end

    def stage?(*names)
      stage.in?(names.flatten.map { |name| name.to_s.downcase })
    end
  end
end
