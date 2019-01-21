# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Research::ClassFactory, type: :model do
    subject(:factory) { described_class.new(namespace: namespace) }

    context "when no namespace is supplied" do
      let(:namespace) { nil }

      describe "#study" do
        subject { factory.study }

        it { is_expected.to eq(Renalware::Research::Study) }
      end

      describe "#participation" do
        subject { factory.participation }

        it { is_expected.to eq(Renalware::Research::Participation) }
      end

      describe "#investigatorship" do
        subject { factory.investigatorship }

        it { is_expected.to eq(Renalware::Research::Investigatorship) }
      end
    end

    context "when a namespace is supplied but not found" do
      let(:namespace) { "NonExistentNamespace" }

      %i(study participation investigatorship).each do |method|
        describe method.to_s do
          it "raises an error" do
            expect{
              factory.public_send(method)
            }.to raise_error(Research::ClassFactory::UnresolvedResearchNamespaceOrClassError)
          end
        end
      end
    end

    context "when a namespace is supplied and it exists" do
      let(:namespace) { "Renalware::Research::MyStudy" }

      # Define custom classes to simulate a study that has defined these in order to specify
      # its own Document (jsonb) class thereby adding custom properties.
      module Research
        module MyStudy
          class Study < Research::Study
          end

          class Participation < Research::Participation
          end

          class Investigatorship < Research::Investigatorship
          end
        end
      end

      describe "#study" do
        subject { factory.study }

        it { is_expected.to eq(Renalware::Research::MyStudy::Study) }
      end

      describe "#participation" do
        subject { factory.participation }

        it { is_expected.to eq(Renalware::Research::MyStudy::Participation) }
      end

      describe "#investigatorship" do
        subject { factory.investigatorship }

        it { is_expected.to eq(Renalware::Research::MyStudy::Investigatorship) }
      end
    end
  end
end
