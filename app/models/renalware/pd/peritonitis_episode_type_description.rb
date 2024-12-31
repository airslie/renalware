module Renalware
  module PD
    class PeritonitisEpisodeTypeDescription < ApplicationRecord
      has_many :peritonitis_episode_types,
               class_name: "PD::PeritonitisEpisodeType"
    end
  end
end
