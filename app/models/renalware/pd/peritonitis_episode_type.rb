module Renalware
  module PD
    class PeritonitisEpisodeType < ApplicationRecord
      belongs_to :peritonitis_episode_type_description,
                 class_name: "PD::PeritonitisEpisodeTypeDescription"
      belongs_to :peritonitis_episode,
                 class_name: "PD::PeritonitisEpisode",
                 touch: true
    end
  end
end
