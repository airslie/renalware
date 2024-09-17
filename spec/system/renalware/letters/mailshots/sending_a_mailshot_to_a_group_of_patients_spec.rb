# frozen_string_literal: true

describe "Creating a mailshot", js: true do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

  def create_test_sql_view(name = "letter_mailshot_test")
    ActiveRecord::Base.connection.execute(Arel.sql(<<-SQL.squish))
      create or replace view #{name}
      as select id as patient_id from patients;
    SQL
  end

  it "the happy path" do
    test_description = "Test mailshot"
    patient = create(
      :patient,
      family_name: "JONES",
      given_name: "Jack",
      nhs_number: "9999999999",
      sex: "M"
    )
    create_test_sql_view
    user = login_as_super_admin
    create(:letter_letterhead, name: "MyLetterhead")

    po = Pages::Letters::Mailshots::Form.new
    po.navigate_here_from_admin_dashboard
    expect(page).to have_content("New mailshot")
    po.description = test_description
    po.letterhead = "MyLetterhead"
    po.author = user
    po.body = "This is the body of the letter"

    # Selecting a sql view will populate the patient preview div via ajax
    po.sql_view_name = "letter_mailshot_test"
    expect(page).to have_css("#mailshot-patients-preview tbody tr")
    within(po.patient_preview_table) do
      expect(page).to have_content("JONES, Jack")
      expect(page).to have_content("9999999999")
    end

    # In this end-to-end test we are going to force the enqueues CreateMailshotLettersJob
    # job to execute now so we can carry on test the outcome - ie it created the letters.
    # It makes this test less easy to read but worth it to have this end-to-end test.
    perform_enqueued_jobs do
      po.submit
      expect(page).to have_current_path(letters_mailshots_path)
    end

    pending "Resolve Delivery::Mesh::SendMessageJob::GPNotInRecipientsError: " \
            "'letter should not be sent' error"

    # The mailshot was created, and the job to create the letter has been
    # executed inline (see above).
    within("table.mailshots") do
      expect(page).to have_content(l(Time.zone.today)) # the date part of created_at
      expect(page).to have_content("Test mailshot") # description
      expect(page).to have_content(user.to_s) # author
      expect(page).to have_content("SUCCESS") # status
    end

    # Check the letter was created
    expect(Renalware::Letters::Letter.count).to eq(1)
    expect(Renalware::Letters::Letter.first).to have_attributes(
      description: test_description,
      patient_id: patient.id,
      author: user,
      type: "Renalware::Letters::Letter::Approved",
      salutation: "Dear Jack JONES"
    )

    # Check we created a mailshot and child mailshot_letters correctly..
    mailshot = Renalware::Letters::Mailshots::Mailshot.last
    expect(mailshot).to have_attributes(
      description: test_description,
      letters_count: 1,
      status: "success"
    )
    # .. and 1 mailshot item
    expect(Renalware::Letters::Mailshots::Item.count).to eq(1)
  end
end
