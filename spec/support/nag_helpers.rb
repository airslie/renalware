module NagHelpers
  def create_nag(severity: :high, date: "2020-01-01", value: "Xxx", nag_definition: definition)
    Renalware::System::Nag.new(
      date: date,
      value: value,
      definition: nag_definition,
      severity: severity
    )
  end
end
