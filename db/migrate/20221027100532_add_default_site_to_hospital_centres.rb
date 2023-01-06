class AddDefaultSiteToHospitalCentres < ActiveRecord::Migration[6.0]
  def change
    add_column :hospital_centres, :default_site, :boolean, default: false
  end
end
