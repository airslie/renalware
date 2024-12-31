RSpec::Matchers.define :validate_timeliness_of do |attribute|
  match do |model|
    model._validators[attribute.to_sym].detect do |validator|
      validator.instance_of?(ActiveModel::Validations::TimelinessValidator) &&
        validator.attributes.include?(attribute)
    end
  end

  failure_message do |_actual|
    "expect #{attribute} to validate timeliness of"
  end

  failure_message_when_negated do |_actual|
    "expect #{attribute} to not validate timeliness of"
  end
end
