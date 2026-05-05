describe "View unreconciled messages" do
  it "displays a list of messages downloaded from the MESH inbox, that for some reason " \
     "we could not match to an outgoing send_messages operation" do
    # Perhaps they were sent to our mailbox by mistake
    login_as_clinical

    Renalware::Letters::Transports::Mesh::Operation.create!(
      action: :download_message,
      transmission_id: nil,
      parent_id: nil,
      reconciliation_error: true,
      mesh_message_id: "ABC123",
      reconciliation_error_description: "reconciliation_error1"
    )

    visit letters_transports_mesh_unreconciled_messages_path

    expect(page).to have_text("Unreconciled Messages")
    expect(page).to have_text("reconciliation_error1")
    expect(page).to have_text("ABC123")
  end
end
