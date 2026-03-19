module Renalware
  Rails.benchmark "Adding HD Providers" do
    HD::Provider.find_or_create_by!(name: "Diaverum")
    HD::Provider.find_or_create_by!(name: "Fresenius")
    HD::Provider.find_or_create_by!(name: "Nikkiso")
  end
end
