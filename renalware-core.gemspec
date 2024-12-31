# frozen_string_literal: false

# rubocop:disable Style/ExpandPathArguments,Style/SpecialGlobalVars
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "lib/renalware/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.metadata["rubygems_mfa_required"] = "true"
  s.name        = "renalware-core"
  s.version     = Renalware::VERSION
  s.required_ruby_version = ">= 3.3"
  s.authors     = ["Airslie"]
  s.email       = ["dev@airslie.com"]
  s.homepage    = "https://github.com/airslie/renalware-core"
  s.summary     = "Renalware core functionality as a mountable engine."
  s.description = "Renalware uses demographic, clinical, pathology, and nephrology datasets to " \
                  "improve patient care, undertake clinical and administrative audits and share " \
                  "data with external systems."
  s.license     = "MIT"

  # Note that no spec or feature files are included, so no demo data is shipped with the gem
  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "vendor/assets/**/*",
    "spec/factories/**/*",
    "spec/support/**/*",
    "Rakefile",
    "README.md",
    "MIT-LICENSE"
  ]

  s.add_dependency "activerecord-import", "~> 1.0"
  s.add_dependency "activerecord-postgres_enum", "~> 2.0"
  s.add_dependency "acts_as_list", "~> 1.1"
  s.add_dependency "after_commit_everywhere"
  s.add_dependency "ahoy_matey"
  s.add_dependency "attr_extras"
  s.add_dependency "bcrypt_pbkdf"
  s.add_dependency "client_side_validations"
  s.add_dependency "client_side_validations-simple_form"
  s.add_dependency "clipboard-rails", "~> 1.7.1"
  s.add_dependency "cocoon", "~> 1.2.11"
  s.add_dependency "combine_pdf", "~> 1.0.26"
  s.add_dependency "concurrent-ruby", "~> 1.1"
  s.add_dependency "cronex", "~> 0.6"
  s.add_dependency "delayed_job", "~> 4.1.4"
  s.add_dependency "delayed_job_active_record", "~> 4.1.2"
  s.add_dependency "devise", "~> 4.8"
  s.add_dependency "devise-security" # , "~> 0.14.3"
  s.add_dependency "diff-lcs"
  s.add_dependency "diffy"
  s.add_dependency "dotenv-rails"
  s.add_dependency "dumb_delegator", "~> 1.1"
  s.add_dependency "ed25519"
  s.add_dependency "email_validator", "> 1.6.0"
  s.add_dependency "enumerize", "~> 2.5"
  s.add_dependency "faraday"
  s.add_dependency "faraday-retry"
  s.add_dependency "fhir_models"
  s.add_dependency "font-awesome-sass", "~> 5.6" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
  s.add_dependency "friendly_id", "~> 5.3"
  s.add_dependency "fugit", ">= 1.1"
  s.add_dependency "groupdate", ">= 4.2", "< 7"
  s.add_dependency "hashdiff", "~> 1.0"
  s.add_dependency "httparty", "~> 0.16"
  s.add_dependency "i18n" # , "~> 1.8.9"
  s.add_dependency "inline_svg", "~> 1.8"
  s.add_dependency "jbuilder", "~> 2.8"
  s.add_dependency "jquery-rails", "~> 4.4"
  s.add_dependency "jquery-ui-rails", ">= 6.0.1", "< 7.1.0"
  s.add_dependency "kaminari", "~> 1.1"
  s.add_dependency "liquid", "~> 5.6"
  s.add_dependency "lograge", "~> 0.11"
  s.add_dependency "naught", "~> 1.1.0"
  s.add_dependency "nested_form", "~> 0.3.2"
  s.add_dependency "net-sftp", "~> 4.0"
  s.add_dependency "nokogiri", "~> 1.9"
  s.add_dependency "ox", "~> 2.13"
  s.add_dependency "pagy", "~> 9.0"
  s.add_dependency "pandoc-ruby", "~> 2.1.4"
  s.add_dependency "paper_trail"
  s.add_dependency "paranoia", "~> 3.0"
  s.add_dependency "pdf-reader", "~> 2.9"
  s.add_dependency "pg", "~> 1.1"
  s.add_dependency "prawn", "~> 2.5.0"
  s.add_dependency "psych", "~>5.1.2" # required for ruby 3.x to avoid invalid database.yml error
  s.add_dependency "puma", ">= 4.3"
  s.add_dependency "pundit", "~> 2.4.0"
  s.add_dependency "rack"
  s.add_dependency "rack-attack"
  s.add_dependency "rails"
  s.add_dependency "ransack", "~> 4.2.0"
  s.add_dependency "rqrcode", "~> 2.0"
  s.add_dependency "ruby-hl7", "~> 1.3.3"
  s.add_dependency "sassc-rails", "~> 2.1.0"
  s.add_dependency "scenic", "~> 1.5"
  s.add_dependency "simple_form", "~> 5.1"
  s.add_dependency "sinatra"
  s.add_dependency "slim-rails"
  s.add_dependency "sprockets-rails"
  s.add_dependency "store_model", "< 5"
  s.add_dependency "turbo-rails", "2.0.11" # matches "@hotwired/turbo-rails" => "8.0.12"
  s.add_dependency "validates_timeliness"
  s.add_dependency "view_component", "< 4.0"
  s.add_dependency "virtus", "~> 1.0.5"
  s.add_dependency "wicked_pdf", "~> 2.8.0"
  s.add_dependency "wisper", "~> 3.0.0"
  s.add_dependency "wisper-activejob", "~> 1.0.0"
  s.add_dependency "yard", ">= 0.9.35"
end
# rubocop:enable Style/ExpandPathArguments,Style/SpecialGlobalVars
