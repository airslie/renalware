# frozen_string_literal: true

module Renalware
  describe Letters::LetterParamsProcessor do
    describe "#assign_description_from_topic_if_empty" do
      let(:instance) { described_class.new(patient) }
      let(:params) { {} }
      let(:patient) { Patient.new }

      context "when neither topic or description is passed in as a parameter" do
        it do
          expect(instance.call(params)[:description]).to be_nil
        end
      end

      context "when topic_id is empty string" do
        let(:params) { { topic_id: "" } }

        it do
          expect(instance.call(params)[:description]).to be_nil
        end
      end

      context "when description is passed in as a parameter" do
        let(:params) { { description: "test descr" } }

        it "sets the description as a parameter" do
          expect(instance.call(params)[:description]).to eq("test descr")
        end
      end

      context "when description is not passed as a parameter" do
        let(:topic) { build_stubbed(:letter_topic, text: "test topic descr") }
        let(:params) { { topic_id: topic.id } }

        context "when topic id is passed in" do
          before do
            allow(Letters::Topic).to receive(:find).with(topic.id).and_return(topic)
          end

          it "uses the topic's text" do
            expect(instance.call(params)[:description]).to eq("test topic descr")
          end
        end
      end
    end
  end
end
