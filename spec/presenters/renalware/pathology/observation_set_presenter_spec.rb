# frozen_string_literal: true

module Renalware
  module Pathology
    describe ObservationSetPresenter do
      describe "method_missing" do
        describe "delegates .obx* calls to the underlying hash in order to create helper methods" do
          context "when there is an observation set with one hgb observation" do
            subject(:presenter) do
              observation_set = CurrentObservationSet.new(
                values: ObservationsJsonbSerializer.load(HGB: hgb)
              )
              described_class.new(observation_set)
            end

            let(:hgb) { { "result" => "123.4", "observed_at" => "2017-12-12" } }

            it "returns the whole observation using set.<obx_code>" do
              allow(AllObservationCodes.instance).to receive(:all).once.times.and_return([:HGB])

              expect(presenter.hgb).to eq(hgb)
              expect(AllObservationCodes.instance).to have_received(:all)
            end

            it "returns the observation result using set.<obx_code>_result" do
              expect(presenter.hgb_result).to eq(hgb["result"])
            end

            it "returns the observation date using set.<obx_code>observed_at" do
              expect(presenter.hgb_observed_at).to eq(Date.parse(hgb["observed_at"]))
            end
          end
        end
      end
    end
  end
end
