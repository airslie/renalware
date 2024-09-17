# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  # For zeitwerk, handle the gem convention where the file version.rb
  # does not define a constant Version. Alternatively we could move
  # the version number someone else.
  # (untested!)
  # def camelize(basename, abspath)
  #   abspath == app_version ? "VERSION" : basename.camelize
  # end

  inflect.acronym "ACR"
  inflect.acronym "AKI"
  inflect.acronym "AKCC"
  inflect.acronym "APD"
  inflect.acronym "API"
  inflect.acronym "BLT"
  inflect.acronym "BMI"
  inflect.acronym "CAPD"
  inflect.acronym "CC"
  inflect.acronym "CCs"
  inflect.acronym "CM"
  inflect.acronym "CSV"
  inflect.acronym "CRF"
  inflect.acronym "DNA"
  inflect.acronym "EDTA"
  inflect.acronym "ESRF"
  inflect.acronym "FHIR"
  inflect.acronym "GMC"
  inflect.acronym "GP"
  inflect.acronym "HD"
  inflect.acronym "HDF"
  inflect.acronym "HIV"
  inflect.acronym "HL7"
  inflect.acronym "ITK3"
  inflect.acronym "ITK"
  inflect.acronym "MDM"
  inflect.acronym "MDMs"
  inflect.acronym "MS"
  inflect.acronym "NHS"
  inflect.acronym "NHS"
  inflect.acronym "ODS"
  inflect.acronym "OBX"
  inflect.acronym "PD"
  inflect.acronym "PET"
  inflect.acronym "PRD"
  inflect.acronym "PV1"
  inflect.acronym "PV2"
  inflect.acronym "RaDaR"
  inflect.acronym "RTF"
  inflect.acronym "SFTP"
  inflect.acronym "TRUD"
  inflect.acronym "UKRDC"
  inflect.acronym "XHR"
  inflect.acronym "EQ5D"
  inflect.acronym "EQ5D5L"
  # inflect.acronym "POS" # DO NOT USE: breaks Devise/Responders which will translate POST to POS_T!
  inflect.acronym "YAML"
  inflect.acronym "KFRE"
  inflect.irregular "feedback", "feedback"
  inflect.acronym "NHS"
  inflect.acronym "DMD"
  inflect.acronym "VMP"
  inflect.acronym "QR"
  inflect.acronym "VND"
  inflect.uncountable %w(cache)
end
