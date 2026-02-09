module Renalware
  Rails.benchmark "Adding HD Providers" do
    unit = Hospitals::Unit.find_by(unit_code: "MOUNT")
    provider = HD::Provider.find_by(name: "Diaverum")
    HD::ProviderUnit.find_or_create_by!(
      hospital_unit: unit,
      hd_provider: provider,
      providers_reference: "1831"
    )
  end
end
