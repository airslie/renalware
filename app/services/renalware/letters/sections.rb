class Renalware::Letters::Sections
  ADDITIONAL_MAPPINGS = {
    "akcc" => "low_clearance"
  }.freeze

  def initialize(patient, section)
    @section = LETTER_SECTIONS_YAML[section.to_sym] if section
    @patient = patient
    @as = {}
  end

  # Creates a hash of labels and values as described in the config/letter_sections.yml
  # file. See doc/letter_sections.md for more information.
  def all
    @section.map do |row|
      row.filter_map do |field|
        values = Array(field[:path]).map { |path| method_dig(path) }
        next if values.any?(&:blank?)

        {
          label: label_for(field[:label]),
          value: values.join(field[:separator] || "")
        }
      end
    end.reject(&:empty?)
  end

  private

  # If label is a path, it's looked up the same way as the `path` and allows
  # dynamic labels. This is currently used for Immunosuppressive.
  def label_for(label)
    return label unless path?(label)

    method_dig(label)
  end

  # Returns true if the label is actually a path, mainly determined by
  # ending with "_patient".
  def path?(label)
    return false if label.include?(" ")

    label.split(".").first.end_with?("_patient")
  end

  # Looks up the value for the given path starting with the patient class. It's
  # like dig but with a chain of methods calls. It also handles the optional
  # type suffix. See doc/letter_sections.md for more information.
  def method_dig(path)
    path, type = path.split(":")
    path = path.split(".")
    patient = as path.shift

    value = path.reduce(patient) { |o, k| o&.public_send(k) if o.respond_to?(k) }
    return unless value

    type ? apply_type(value, type) : apply_inferred_type(value)
  end

  def apply_inferred_type(value)
    return I18n.l(value.to_date) if value.is_a?(Date)
    return I18n.l(value) if value.is_a?(Time) || value.is_a?(DateTime)
    return value ? "Yes" : "No" if [true, false].include?(value)

    value
  end

  def apply_type(value, type)
    return I18n.l(value.to_date) if type == "date"
    return Renalware::Duration.from_minutes(value).to_s if type == "duration"
    return value.round if type == "integer"
    return "#{value}%" if type == "percentage"

    "#{value} #{type}"
  end

  # Accepts a namespace e.g. "hd_patient" and returns the correct class
  # e.g. Renalware::HD::Patient
  # Special case for "akcc_patient" which is Renalware::LowClearance::Patient
  def as(namespace)
    raise "Unknown patient class #{namespace}" unless namespace.end_with?("_patient")

    patient_namespace = namespace.split("_").first
    if ADDITIONAL_MAPPINGS.key?(patient_namespace)
      patient_namespace = ADDITIONAL_MAPPINGS[patient_namespace]
    end

    patient_class = Renalware.const_get("#{patient_namespace.camelize}::Patient")

    @as[namespace] ||= @patient.becomes(patient_class)
  end
end
