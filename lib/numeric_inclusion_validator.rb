# Note I did want to put this validator in lib but I could not get it to load
# if put in app/validators. Probably something dumb I was doing, so it could be good
# to move this file later if you can get to the bottom of the issue.
# (I wondered if it was to do with load order - the model loading before the validator -
# although other validators are not exhibiting this issue)
# --------------------------------------------------------------------------------------
# This is a sub-class of the rails InclusionValidator that will use a different
# validation I18n message with `to` and `from` arguments.
#
# Rather than "is not included in the list", you can use the I18n args to build a
# more helpful more helpful message, e.g.:
# activerecord:
#   errors:
#    messages:
#      numeric_inclusion: "must be between %{from} and %{to}"

class NumericInclusionValidator < ActiveModel::Validations::InclusionValidator
  def validate_each(record, attribute, value)
    delimiter = options[:in]
    exclusions = delimiter.respond_to?(:call) ? delimiter.call(record) : delimiter
    unless exclusions.send(inclusion_method(exclusions), value)
      i18n_args = options
        .except(:in)
        .merge!(value: value, from: delimiter.first, to: delimiter.last)
      record.errors.add(attribute, :numeric_inclusion, **i18n_args)

      # record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end
