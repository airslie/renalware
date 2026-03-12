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
          if episode.save
            save_episode_types(episode.episode_types, params)
          else
            assign_episode_types_for_redisplay(episode, params)
            false
          end
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

      def assign_episode_types_for_redisplay(episode, params)
        episode.association(:episode_types).target = episode_type_descriptions_from(params, episode)
      end

      def episode_type_descriptions_from(params, episode)
        params.fetch(:episode_types, []).compact_blank.map do |desc_id|
          PeritonitisEpisodeType.new(
            peritonitis_episode: episode,
            peritonitis_episode_type_description_id: desc_id
          )
        end
      end
    end
  end
end
