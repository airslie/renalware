class AddInclusionDatesToSystemOnlineReferenceLinks < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :system_online_reference_links,
                 :include_in_letters_from,
                 :date,
                 comment: "If set, the QR code will be included in any new letters created on or" \
                          "after this date - ie its the start of the window of auto-inclusion"
      add_column :system_online_reference_links,
                 :include_in_letters_until,
                 :date,
                 comment: "If 'include_in_letters_from' is set, letters created after this date " \
                          "will no longer have the QR code automatically inserted - " \
                          "ie its the end of the window of auto-inclusion"
    end
  end
end
