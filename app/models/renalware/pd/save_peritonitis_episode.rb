module Renalware
  module PD
    class SavePeritonitisEpisode
      include Wisper::Publisher

      def initialize(patient:, episode:)
        @patient = patient
        @episode = episode
      end

      def call(params:)
        success = save_episode(episode, params)
        success ? broadcast(:save_success, episode) : broadcast(:save_failure, episode)
        success
      end

      private

      attr_reader :patient, :episode

      def episodes
        patient.peritonitis_episodes
      end

      def save_episode(episode, params)
        PeritonitisEpisode.transaction do
          episode.assign_attributes(params.except(:episode_types))
          episode.save && save_episode_types(episode.episode_types, params)
        end
      end

      def save_episode_types(episode_types, params)
        episode_type_desc_ids = params.fetch(:episode_types, [])
        episode_types.destroy_all
        episode_type_desc_ids.each do |desc_id|
          episode_types.create!(peritonitis_episode_type_description_id: desc_id)
        end
        true
      end
    end
  end
end
