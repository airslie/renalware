require_relative "lib/relay/gp_connect/version"

Gem::Specification.new do |spec|
  spec.name = "relay-gp_connect"
  spec.version = Relay::GPConnect::VERSION
  spec.authors = ["Airslie"]
  spec.summary = "NHS GP Connect 'Send Document' over MESH: payload building and MESH API client"
  spec.description = <<~TEXT
    Builds the FHIR STU3 'GP Connect Send Document' message for a letter and talks to the MESH
    API to send it and read the responses. It has no dependency on Rails, ActiveRecord or on
    Renalware: callers describe what to send with a Relay::GPConnect::DeliveryRequest and supply
    their settings in a Relay::GPConnect::Mesh::Config, and store results however they like.
  TEXT
  spec.required_ruby_version = ">= 4.0"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday"
  spec.add_dependency "fhir_stu3_models"
  spec.add_dependency "nokogiri"
end
