# frozen_string_literal: true

module Renalware
  module PD
    describe PeritonitisEpisodeType do
      it :aggregate_failures do
        is_expected.to belong_to(:peritonitis_episode_type_description)
        is_expected.to belong_to(:peritonitis_episode)
      end
    end
  end
end
