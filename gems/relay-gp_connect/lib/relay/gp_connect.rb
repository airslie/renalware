require "date"
require "securerandom"
require "time"
require "zeitwerk"
require "nokogiri"
require "fhir_stu3_models"
require "active_support"
require "active_support/concern"
require "active_support/core_ext/enumerable"
require "active_support/core_ext/object/blank"
require "relay/gp_connect/version"

module Relay
  # Sending documents to a patient's GP using the NHS GP Connect 'Send Document' workflow over
  # MESH. See the README for the shape of the pieces.
  module GPConnect
    def self.loader
      @loader ||= Zeitwerk::Loader.new.tap do |loader|
        loader.tag = "relay-gp_connect"
        loader.push_dir(File.expand_path("..", __dir__))
        loader.ignore(File.expand_path("gp_connect/version.rb", __dir__)) # defines VERSION
        loader.inflector.inflect(
          "gp_connect" => "GPConnect",
          "fhir" => "FHIR",
          "itk" => "ITK",
          "itk3_response" => "ITK3Response"
        )
      end
    end
  end
end

Relay::GPConnect.loader.setup
