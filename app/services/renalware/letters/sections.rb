class Renalware::Letters::Sections
  PATIENT_CLASSES = {
    patient: Renalware::Patient,
    accesses_patient: Renalware::Accesses::Patient,
    akcc_patient: Renalware::LowClearance::Patient,
    clinical_patient: Renalware::Clinical::Patient,
    clinics_patient: Renalware::Clinics::Patient,
    hd_patient: Renalware::HD::Patient,
    pathology_patient: Renalware::Pathology::Patient,
    pd_patient: Renalware::PD::Patient,
    transplants_patient: Renalware::Transplants::Patient
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

  # Returns true if the label is actually a path. It does this by checking if
  # the first part of the label matches a key in PATIENT_CLASSES.
  def path?(label)
    PATIENT_CLASSES.key?(label.split(".").first.to_sym)
  end

  # Looks up the value for the given path starting with the patient class. It's
  # like dig but with a chain of methods calls. It also handles the optional
  # type suffix. See doc/letter_sections.md for more information.
  def method_dig(path)
    path, type = path.split(":")
    path = path.split(".")
    patient = as path.shift.to_sym

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

  def as(patient_class)
    raise "Unknown patient class #{patient_class}" unless PATIENT_CLASSES.key?(patient_class)

    @as[patient_class] ||= @patient.becomes(PATIENT_CLASSES[patient_class])
  end
end
