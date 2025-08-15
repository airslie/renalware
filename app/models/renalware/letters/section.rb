module Renalware
  module Letters
    class Section
      attr_reader :patient, :letter

      def initialize(letter:, section_identifier: nil)
        @patient = letter.patient
        @letter = letter
        @section_identifier = section_identifier
      end

      def content_with_diffs
        diffy_diff.to_a.empty? ? build_snapshot : CGI.unescapeHTML(diffy_diff.to_s(:html)).html_safe
      end

      def show_use_updates_toggle?(preview_topic_id)
        letter.persisted? &&
          diffy_diff.to_a.any? &&
          (preview_topic_id.blank? || preview_topic_id == letter.topic_id.to_s)
      end

      def build_snapshot
        @snapshot ||= ApplicationController.renderer.render(
          partial: "renalware/letters/sections/snapshot",
          locals: {
            letter: letter,
            section_identifier: @section_identifier
          }
        )
      end

      private

      def diffy_diff
        @diffy_diff ||= Diffy::Diff.new(snapshotted, build_snapshot, format: :html,
                                                                     ignore_crlf: true)
      end

      def snapshotted
        self.class.content_from_snapshot(letter: letter).to_s.html_safe
      end

      class << self
        def identifier
          name.demodulize.underscore.to_sym
        end

        def content_from_snapshot(letter:)
          section_identifier = letter.topic&.section_identifier
          return unless section_identifier

          Letters::SectionSnapshot.find_by(section_identifier:, letter:)&.content
        end
      end
    end
  end
end
