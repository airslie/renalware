# frozen_string_literal: true

module Renalware
  module Letters
    describe Section do
      let(:letter) { instance_double(Letter, patient: double) }
      let(:instance) { described_class.new(letter: letter) }

      describe "#content_with_diffs" do
        let(:build_snapshot) { "<b>new</b> snapshot" }

        before do
          allow(described_class)
            .to receive(:content_from_snapshot).with(letter: letter).and_return("snapshotted")
          allow(instance)
            .to receive(:build_snapshot).and_return(build_snapshot)
        end

        context "when there are no differences between snapshotted and current" do
          let(:build_snapshot) { "snapshotted" }

          it "returns the new snapshot" do
            expect(instance.content_with_diffs).to eq "snapshotted"
          end
        end

        # rubocop:disable Layout/LineLength
        context "when there are differences between snapshotted and current" do
          it "returns a diff in an HTML escaped form, and html safed" do
            expect(instance.content_with_diffs).to eq \
              %Q(<div class="diff">\n  <ul>\n    <li class="del"><del>snapshot<strong>ted</strong></del></li>\n    <li class="ins"><ins><strong><b>new</b> </strong>snapshot</ins></li>\n  </ul>\n</div>\n)
          end
        end
        # rubocop:enable Layout/LineLength
      end

      describe "#show_use_updates_toggle?" do
        let(:letter) {
          instance_double(Letter, patient: double, topic_id: "21", persisted?: persisted)
        }
        let(:persisted) { true }
        let(:preview_topic_id) { "21" }
        let(:diffy_result) { ["something"] }
        let(:diffy) { instance_double(Diffy::Diff, to_a: diffy_result) }

        subject { instance.show_use_updates_toggle?(preview_topic_id) }

        before do
          allow(instance).to receive(:diffy_diff).and_return diffy
        end

        context "when letter is persisted" do
          context "when diff is not empty" do
            context "when preview_topic_id parameter is same as topic_id on letter" do
              it { is_expected.to be true }
            end

            context "when preview_topic_id parameter is different to topic_id on letter" do
              let(:preview_topic_id) { "999" }

              it { is_expected.to be false }
            end
          end

          context "when diff is empty" do
            let(:diffy_result) { [] }

            it { is_expected.to be false }
          end
        end

        context "when letter is not persisted" do
          let(:persisted) { false }

          it { is_expected.to be false }
        end
      end
    end
  end
end
