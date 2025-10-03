# frozen_string_literal: true

class Shared::DetailItem < Shared::DescriptionListItem
  include Renalware::BooleanHelper

  def initialize(record, field, **attrs)
    label = attrs.delete(:label)
    label = "#{label}:" unless label.is_a?(Symbol) || label.nil?
    label = attr_name(record, label || field) if label.is_a?(Symbol) || label.nil?
    raw_value = record.public_send(field)
    value = format_value(raw_value)

    super(label, value, **attrs)
  end

  private

  def format_value(value)
    return yes_no(value) if [true, false].include?(value)
    return t_enum(value) if value.is_a?(Enumerize::Value)

    value
  end

  def t_enum(value)
    value.text
  end
end
