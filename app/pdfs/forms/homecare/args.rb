# frozen_string_literal: true

class Forms::Homecare::Args
  include Virtus.model
  include ActiveModel::Validations

  class Medication
    include Virtus.model(strict: true)
    include ActiveModel::Validations

    attribute :date, Date
    attribute :drug, String
    attribute :dose, String
    attribute :route, String
    attribute :frequency, String
  end

  # The first 2 attrbutes are used to drive what PDF to build
  attribute :provider, String
  attribute :version, Integer
  attribute :title, String, default: ""
  attribute :given_name, String
  attribute :family_name, String
  attribute :nhs_number, String, default: ""
  attribute :born_on, Date
  attribute :modality, String, default: ""
  attribute :fmc_patient, String, default: ""
  attribute :telephone, String, default: ""
  attribute :hospital_number, String, default: ""
  attribute :address, Array(String), default: []
  attribute :postcode, String, default: ""
  attribute :modality, String
  attribute :prescriber_name, String, default: ""
  attribute :prescription_date, Date
  attribute :hospital_name, String
  attribute :hospital_department, String
  attribute :hospital_address, Array(String)
  attribute :hospital_telephone, String
  attribute :po_number, String
  attribute :generated_at, DateTime
  attribute :no_known_allergies, Boolean
  attribute :allergies, Array(String)
  attribute :drug_type, String
  attribute :administration_route, String
  attribute :administration_frequency, String
  attribute :prescription_duration, String
  attribute :administration_device, String
  attribute :medications, Array(Medication)
  attribute :consultant, String
  attribute :delivery_frequencies, Array(String), default: ["3 months", "6 months"]
  attribute :selected_delivery_frequency, String # e.g. "6 months"
  attribute :prescription_durations, Array(String) # e.g. ["3 months", "6 months"]
  attribute :selected_prescription_duration, String # e.g. "3 months"

  validates :family_name, presence: true
  validates :given_name, presence: true
  validates :provider, presence: true
  validates :version, presence: true
  validate :medications_are_present

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.test_data(provider: :generic, version: 1)
    new.tap do |args|
      args.provider = provider
      args.version = version
      args.title = "Mr"
      args.given_name = "Jack"
      args.family_name = "JONES"
      args.nhs_number = "0123456789"
      args.born_on = Date.parse("2001-01-01")
      args.fmc_patient = "123"
      args.telephone = "07000 000001"
      args.hospital_number = "ABC123"
      args.modality = "PD"
      args.address = ["line1", "", nil, "line2", "line3   "]
      args.postcode = "TW1 1UU"
      args.modality = "HD"
      args.prescriber_name = "Dr X Yz"
      args.prescription_date = Date.current.to_s
      args.consultant = "Dr Pepper"
      args.hospital_name = "THE ROYAL LONDON HOSPITAL"
      args.hospital_telephone = "0000 000001"
      args.hospital_department = "Renal"
      args.hospital_address = [
        nil,
        "WHITECHAPEL",
        "",
        "LONDON",
        "E1 1FR",
        "UK",
        "Tel: 0800 00000000",
        "Another line"
      ]
      args.no_known_allergies = false
      args.allergies = ["Nuts", nil, "Penicillin", "Mown grass"]
      args.drug_type = "ESA"
      args.administration_frequency = "Daily"
      args.administration_route = "Per Oral"
      args.prescription_duration = "1 month"
      args.administration_device = "device?"
      args.po_number = "P123"
      args.generated_at = Time.current
      args.delivery_frequencies = ["1 week", "3 months", "6 months", "12 month"]
      args.prescription_durations = ["3 months", "6 months", "12 months"]
      args.selected_prescription_duration = "6 months"

      args.medications << Medication.new(
        date: Date.current,
        drug: "Example drug",
        dose: "1 unit",
        route: "PO",
        frequency: "3"
      )

      raise ArgumentError, args.errors unless args.valid?
    end
  end

  def patient_name
    name = [family_name, given_name].compact.join(", ")
    name += " (#{title})" if title.to_s != ""
    name
  end

  def formatted_address
    format_address_array address
  end

  def formatted_address_and_postcode
    format_address_array(address << postcode)
  end

  def formatted_hospital_address
    format_address_array hospital_address
  end

  def formatted_hospital_name_and_address
    arr = [hospital_name] + hospital_address
    format_address_array arr
  end

  def format_address_array(add)
    return unless add.is_a?(Array)

    add.compact.reject { |line| line == "" }.uniq&.join("\n")
  end

  def formatted_prescription_date
    return unless prescription_date

    prescription_date
  end

  def allergies_as_list
    Array(allergies).uniq.compact.join("<br>")
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def medications_are_present
    if medications.empty?
      errors.add(:base, "There are no home delivery prescriptions for this drug type")
    end
  end
end
