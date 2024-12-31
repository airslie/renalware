describe "Viewing letter batches" do
  include LettersSpecHelper

  def create_letter_batch
    user = create(:user, family_name: "SMITHE")
    letter = create_letter(
      state: :approved,
      to: :patient,
      patient: create(:letter_patient)
    )
    batch = Renalware::Letters::Batch.create!(by: user)
    batch.items.create(letter: letter)
    batch.reload
  end

  describe "GET index" do
    it "return a list of letter batches" do
      batch = create_letter_batch

      get letters_batches_path

      expect(response).to be_successful
      expect(response.body).to match("SMITHE")
      expect(response.body).to match("1") # batch_tiems_count or id :0)
      expect(response.body).to match(batch.status.humanize)
    end
  end

  # describe "POST create" do
  #   it "creates a new batch assigned to the current user and having all letters defined "\
  #      "by the current query" do

  #     post(
  #       letters_batches_path,
  #       params: {
  #         letters_batch: {
  #           query:
  #         }
  #       }
  #     )

  #     expect(response).to be_successful
  #   end
  # end
end
