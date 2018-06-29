# frozen_string_literal: true

json.array!(
  prescriptions,
  :id,
  :prescribed_on,
  :drug_name,
  :dose,
  :dose_unit,
  :dose_amount,
  :frequency,
  :route_code,
  :route_description,
  :administer_on_hd,
  :last_delivery_date
)
