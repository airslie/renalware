class AddMeshColumnsToPatientPractices < ActiveRecord::Migration[7.0]
  def change
    # Note that a mesh_mailbox_id is linked to a combination of ODS code and MESH workflow (eg
    # Transfer of Care Outpatient Letter). While we could normalize to allow >1 mesh mailbox per
    # practice - allowing for other workflow ids - using eg workflows and mailboxes tables,
    # we have kep things simpke for now and just prefixed *mesh_mailbox* columns with 'toc'.
    within_renalware_schema do
      add_column(:patient_practices, :toc_mesh_mailbox_id, :string, comment: <<~COMMENT)
        e.g. YGM24GPXXX. Populated by a call to MESHAPI endpointlookup.
        Used when sending letters using TransferOfCare via MESH.
      COMMENT
      add_column(:patient_practices, :toc_mesh_mailbox_description, :string, comment: <<~COMMENT)
        Mailbox description eg GP Connect TPP Mailbox One.
        Populated by a call to MESHAPI endpointlookup.
      COMMENT
    end
  end
end
