describe "Outgoing document management" do
  it "allows listing outgoing documents for a superadmin" do
    user = login_as_super_admin
    event = create(:swab, by: user)
    doc = Renalware::Feeds::OutgoingDocument.create!(
      renderable: event,
      by: user,
      created_at: 1.day.ago
    )

    visit feeds_outgoing_documents_path(format: :html)

    expect(page).to have_content("Outgoing Documents")
    expect(page).to have_content(user.to_s)
    expect(page).to have_content(doc.id)
    expect(page).to have_content(doc.state)
  end
end
