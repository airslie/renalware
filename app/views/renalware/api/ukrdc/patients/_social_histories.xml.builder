# frozen_string_literal: true

xml = builder

# Currently only used for smoking for which CodingStandard=RRSMOKE Code=YES/NO/EX
xml.SocialHistories do
  if patient.smoking_history.present?
    xml.SocialHistory do
      xml.SocialHabit do
        xml.CodingStandard "RRSMOKE"
        xml.Code patient.smoking_history
      end
    end
  end
end
