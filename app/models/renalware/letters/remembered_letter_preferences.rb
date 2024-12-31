module Renalware
  module Letters
    class RememberedLetterPreferences < RememberedPreferences
      SESSION_KEY = :letter_preferences
      ATTRIBUTES_TO_REMEMBER = %i(letterhead_id topic_id author_id).freeze
    end
  end
end
