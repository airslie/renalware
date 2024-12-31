Given(/^Patty has the following prescriptions:$/) do |table|
  table.hashes.each_with_index do |row, index|
    dose_amount, unit_of_measure_name = row[:dose].split
    prescribed_on_default = Time.current.beginning_of_day - 1.month + index.days

    unit_of_measure = FactoryBot.create(:drug_unit_of_measure, name: unit_of_measure_name)
    route = FactoryBot.create(:medication_route, name: row[:route_name], code: SecureRandom.hex)
    drug = Renalware::Drugs::Drug.find_or_create_by!(name: row[:drug_name])

    prescription = FactoryBot.create(
      :prescription,
      patient: @patty,
      drug: drug,
      unit_of_measure: unit_of_measure,
      medication_route: route,
      dose_amount: dose_amount,
      frequency: row[:frequency],
      prescribed_on: row.fetch("prescribed_on", prescribed_on_default),
      provider: row[:provider].downcase,
      administer_on_hd: row[:administer_on_hd] || false,
      last_delivery_date: "10-10-2015"
    )

    next if row[:terminated_on].blank?

    FactoryBot.create(:prescription_termination,
                      prescription: prescription,
                      terminated_on: Date.parse(row[:terminated_on]))
  end
end

Given(/^Patty is being prescribed (.+)$/) do |drug_name|
  drug = Renalware::Drugs::Drug.find_or_create_by!(name: drug_name)
  FactoryBot.create(:prescription, patient: @patty, drug: drug)
end
