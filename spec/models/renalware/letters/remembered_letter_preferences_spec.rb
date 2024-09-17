# frozen_string_literal: true

module Renalware
  module Letters
    describe RememberedLetterPreferences do
      describe "#persist" do
        it "saves certain model attributes to the session" do
          letter = instance_double(Letter,
                                   letterhead_id: 1,
                                   topic_id: "1",
                                   author_id: 1)
          session = {}

          described_class.new(session).persist(letter)

          RememberedLetterPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(session[:letter_preferences]).to have_key(attr)
          end
        end
      end

      describe "#apply_to" do
        it "copies any previously remembered session data to the letter" do
          session = {
            letter_preferences: {
              letterhead_id: 1,
              topic_id: "1",
              author_id: 1
            }
          }
          letter = OpenStruct.new(letterhead_id: nil,
                                  description: nil,
                                  author_id: nil)

          described_class.new(session).apply_to(letter)

          RememberedLetterPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(letter.public_send(attr)).to eq(session[:letter_preferences][attr])
          end
        end
      end
    end
  end
end
