# frozen_string_literal: false

# rubocop:disable Style/ExpandPathArguments,Style/SpecialGlobalVars
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "renalware/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "renalware-core"
  s.version     = Renalware::VERSION
  s.authors     = ["Airslie"]
  s.email       = ["dev@airslie.com"]
  s.homepage    = "https://github.com/airslie/renalware-core"
  s.summary     = "Renalware core functionality as a mountable engine."
  s.description = "Renalware uses demographic, clinical, pathology, and nephrology datasets to "\
                  "improve patient care, undertake clinical and administrative audits and share "\
                  "data with external systems."
  s.license     = "MIT"

  # Note that no spec or feature files are included, so no dummy data is shipped with the gem
  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "vendor/assets/**/*",
    "spec/factories/**/*",
    "spec/support/**/*",
    "Rakefile",
    "README.md",
    "MIT-LICENSE"
  ]
  s.add_dependency "active_type", "~> 0.7.1"
  s.add_dependency "activerecord-import", "~> 0.22.0"
  s.add_dependency "ahoy_matey", "~> 2.1.0"
  s.add_dependency "attr_extras", "~> 5.2.0"
  s.add_dependency "autoprefixer-rails", "~> 8.4.1"
  s.add_dependency "chosen-rails", "~> 1.8.3"
  s.add_dependency "client_side_validations", "11.0.0"
  s.add_dependency "client_side_validations-simple_form", "~> 6.5.1"
  s.add_dependency "clipboard-rails", "~> 1.7.1"
  s.add_dependency "cocoon", "~> 1.2.11"
  s.add_dependency "cronex", "~> 0.6.1"
  s.add_dependency "delayed_job", "~> 4.1.4"
  s.add_dependency "delayed_job_active_record", "~> 4.1.2"
  s.add_dependency "delayed_job_web", "~> 1.4.3"
  s.add_dependency "devise", "~> 4.5.0"
  s.add_dependency "dotenv-rails", "~> 2.5.0"
  s.add_dependency "dumb_delegator", "~> 0.8.0"
  s.add_dependency "email_validator", "~> 1.6.0"
  s.add_dependency "enumerize", "~> 2.2.2"
  s.add_dependency "font-awesome-rails", "~> 4.7.0.3" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
  s.add_dependency "foundation-rails", "~> 5.5.3.2"
  s.add_dependency "friendly_id", "~> 5.2.3"
  s.add_dependency "gpgme", "~>2.0.16"
  s.add_dependency "hashdiff", "~> 0.3.7"
  s.add_dependency "httparty", "~> 0.16.2"
  s.add_dependency "jbuilder", "~> 2.7.0"
  s.add_dependency "jquery-datatables-rails", "~> 3.4.0"
  s.add_dependency "jquery-rails", "~> 4.3.1"
  s.add_dependency "jquery-ui-rails", "~> 6.0.1"
  s.add_dependency "kaminari", "~> 1.1.1"
  s.add_dependency "liquid", "~> 4.0.0"
  s.add_dependency "lograge", "~> 0.10.0"
  s.add_dependency "naught", "~> 1.1.0"
  s.add_dependency "nested_form", "~> 0.3.2"
  s.add_dependency "nokogiri", "~> 1.8.4"
  s.add_dependency "pandoc-ruby", "~> 2.0.2"
  s.add_dependency "paper_trail", "~> 8.1.2"
  s.add_dependency "paranoia", "~> 2.4.0"
  s.add_dependency "pg", "~> 1.1.2"
  s.add_dependency "puma", "~> 3.12.0"
  s.add_dependency "pundit", "~> 2.0.0"
  s.add_dependency "rack-attack", "~> 5.4.0"
  s.add_dependency "rails", "5.1.6"
  s.add_dependency "rails-assets-foundation-datepicker", "1.5.0" # 1.5.6 causes capybara errors
  s.add_dependency "rails-assets-select2", "~> 4.0.2"
  s.add_dependency "ransack", "~> 2.0.1"
  s.add_dependency "record_tag_helper", "~> 1.0.0"
  s.add_dependency "ruby-hl7", "~> 1.2.0"
  s.add_dependency "sass-rails", "~> 5.0.7"
  s.add_dependency "scenic", "~> 1.4.1"
  s.add_dependency "simple_form", "3.5.0"
  s.add_dependency "sinatra", "~> 2.0.1"
  s.add_dependency "slim-rails", "~> 3.1.3"
  s.add_dependency "trix", "~> 0.11.1"
  s.add_dependency "uglifier", "~> 4.1.17"
  s.add_dependency "underscore-rails", "~> 1.8.3"
  s.add_dependency "validates_timeliness", "~> 4.0.2"
  s.add_dependency "virtus", "~> 1.0.5"
  s.add_dependency "whenever", "~> 0.10.0" # For managing/deploying cron jobs see config/schedule.rb
  s.add_dependency "wicked_pdf", "~> 1.1.0"
  s.add_dependency "wisper", "~> 2.0.0"
  s.add_dependency "wkhtmltopdf-binary", "0.12.3.1"
  s.add_dependency "yard", "~> 0.9.15"
end
# rubocop:enable Style/ExpandPathArguments,Style/SpecialGlobalVars
