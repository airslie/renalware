module Renalware
  module Letters
    class Section
      attr_reader :patient, :letter, :event

      def initialize(letter:, event: Event::Unknown.new)
        @patient = letter.patient
        @letter = letter
        @event = event
      end

      def content_with_diffs
        diffy_diff.to_a.empty? ? build_snapshot : CGI.unescapeHTML(diffy_diff.to_s(:html)).html_safe
      end

      def show_use_updates_toggle?(preview_topic_id)
        letter.persisted? &&
          diffy_diff.to_a.any? &&
          (preview_topic_id.blank? || preview_topic_id == letter.topic_id.to_s)
      end

      def lcs_diff_left
        output = []
        Diff::LCS.traverse_balanced(
          snapshotted, build_snapshot,
          Renalware::Letters::SectionManager::LCSDiffLeftCallbacks.new(output)
        )
        output.join.html_safe
      end

      def lcs_diff_right
        output = []
        Diff::LCS.traverse_balanced(
          snapshotted, build_snapshot,
          Renalware::Letters::SectionManager::LCSDiffRightCallbacks.new(output)
        )
        output.join.html_safe
      end

      def to_edit_partial_path
        "#{to_partial_path}_edit"
      end

      def build_snapshot
        @snapshot ||= ApplicationController.renderer.render(
          partial: "#{to_partial_path}_snapshot",
          locals: {
            letter: letter
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

        def position
          10
        end

        def content_from_snapshot(letter:)
          snapshot = Letters::SectionSnapshot.find_by(
            section_identifier: identifier,
            letter: letter
          )
          snapshot&.content
        end
      end
    end
  end
end
