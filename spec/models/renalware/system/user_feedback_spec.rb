# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::UserFeedback, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:author)
      is_expected.to validate_presence_of(:category)
      is_expected.to validate_presence_of(:comment)
      is_expected.to have_db_index(:author_id)
      is_expected.to enumerize(:category).with_default(:general_comment)
    end
  end
end
