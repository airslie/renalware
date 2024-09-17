# frozen_string_literal: true

module Renalware
  module Snippets
    describe Snippet do
      describe "validation" do
        it :aggregate_failures do
          is_expected.to belong_to(:author)
          is_expected.to validate_presence_of(:title)
          is_expected.to validate_presence_of(:body)
          is_expected.to validate_presence_of(:author)
          is_expected.to validate_presence_of(:times_used)
          is_expected.to validate_numericality_of(:times_used)
        end
      end

      describe "uniqueness" do
        it "does not have a unique title across users" do
          create(:snippet, author: create(:snippets_user), title: "X")

          expect { create(:snippet, author: create(:snippets_user), title: "X") }.not_to raise_error
        end

        it "has a unique title within the scope of a user" do
          author = create(:snippets_user)
          create(:snippet, author: author, title: "X")

          expect {
            create(:snippet, author: author, title: "X")
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe "#record_uasge" do
        it "increments times_used by 1 and updates last_used_on" do
          snippet = create(:snippet, author: create(:snippets_user), title: "X")
          expect(snippet.times_used).to eq(0)

          expect {
            snippet.record_usage.reload
          }.to change { snippet.times_used }.by(1)
        end

        it "updates last_used_on to the current time" do
          freeze_time do
            snippet = create(:snippet, author: create(:snippets_user), title: "X")
            expect(snippet.last_used_on).to be_nil

            snippet.record_usage

            expect(snippet.last_used_on).to eq(Time.zone.now)
          end
        end
      end
    end
  end
end
