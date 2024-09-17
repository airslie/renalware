# frozen_string_literal: true

module Renalware
  module PD
    describe PeritonitisEpisodeTypeDescription do
      it { is_expected.to have_many(:peritonitis_episode_types) }
    end
  end
end
