module Renalware
  module PD
    describe ReviseRegime do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:patient) { create(:patient, by: user) }
      let!(:regime) do
        regime = build(:apd_regime,
                       add_hd: false,
                       patient: patient,
                       end_date: nil,
                       start_date: "01-01-2012")
        regime.bags << build(:pd_regime_bag, :everyday)
        regime.save_by!(other_user)
        regime
      end

      describe "#call" do
        context "when there are no changes to the regime" do
          let(:params) { {} }

          it "does not create a new regime" do
            command = described_class.new(regime)
            expect { command.call(by: user, params: params) }.not_to change(Regime, :count)
          end

          it "does not terminate the regime" do
            command = described_class.new(regime)
            expect { command.call(by: user, params: params) }
              .not_to change(RegimeTermination, :count)
          end

          it "returns true" do
            result = described_class.new(regime).call(by: user, params: params)
            expect(result).to be_success
          end
        end

        context "when changes are invalid" do
          let(:params) { { start_date: "2015-12-01", end_date: "2014-12-01" } }

          it "returns false" do
            result = described_class.new(regime).call(by: user, params: params)
            expect(result).not_to be_success
          end

          it "does not terminate the regime" do
            expect { described_class.new(regime).call(by: user, params: params) }
              .not_to change(RegimeTermination, :count)
          end
        end

        context "when the regime has changes" do
          let(:params) { { add_hd: true } }

          it "creates a new regime" do
            command = described_class.new(regime)
            expect { command.call(by: user, params: params) }.to change(Regime, :count).by(1)
          end

          it "terminates the old regime" do
            expect(Regime.count).to eq(1)
            expect(RegimeTermination.count).to eq(0)

            result = described_class.new(regime).call(by: user, params: params)

            expect(Regime.count).to eq(2)
            expect(RegimeTermination.count).to eq(1)
            expect(RegimeTermination.first.regime).to eq(regime)
            expect(regime.end_date).to eq(result.object.start_date)
          end

          it "sets the current regime to the newly created one" do
            expect(regime).to be_current

            result = described_class.new(regime).call(by: user, params: params)

            expect(result).to be_success
            expect(result.object).to be_current
          end

          it "stores the current user in new and old regimes" do
            result = described_class.new(regime).call(by: user, params: params)

            expect(regime.reload.updated_by).to eq(user)
            expect(regime.reload.created_by).to eq(other_user) # remains unchanged
            new_regime = result.object
            expect(result.object.updated_by).to eq(user)
            expect(new_regime.created_by).to eq(user)
          end

          it "sets the end on the replaced regime to be the start date of new one" do
            freeze_time do
              result = described_class.new(regime).call(by: user, params: params)

              expect(result).to be_success
              expect(regime.end_date).to eq(result.object.start_date)
            end
          end
        end

        context "when there are changes to a bag but not the parent regime" do
          it "creates a new regime" do
            regime_count = Regime.count
            bag_count = RegimeBag.count

            bag = regime.bags.first

            # Bag volume and sunday change
            params = {
              "bags_attributes" => {
                "0" => {
                  "regime_id" => regime.id.to_s,
                  "bag_type_id" => bag.bag_type_id.to_s,
                  "volume" => (bag.volume + 1).to_s,
                  "_destroy" => "false",
                  "sunday" => "1",
                  "monday" => "1",
                  "tuesday" => "1",
                  "wednesday" => "1",
                  "thursday" => "1",
                  "friday" => "1",
                  "saturday" => "1",
                  "id" => bag.id.to_s
                }
              }
            }

            described_class.new(regime).call(by: user, params: params)

            expect(Regime.count).to eq(regime_count + 1)
            expect(RegimeBag.count).to eq(bag_count + 1)
          end
        end

        context "when a bag is deleted from a regime with one bag" do
          it "creates a new regime with just one bag" do
            regime.bags << build(:pd_regime_bag, :everyday)
            regime_count = Regime.count
            bag_count = RegimeBag.count

            bag = regime.bags.first

            # Note "_destroy"=>"true",
            params = {
              "bags_attributes" => {
                "0" => {
                  "regime_id" => regime.id.to_s,
                  "bag_type_id" => bag.bag_type_id.to_s,
                  "volume" => (bag.volume + 1).to_s,
                  "_destroy" => "true",
                  "sunday" => "1",
                  "monday" => "1",
                  "tuesday" => "1",
                  "wednesday" => "1",
                  "thursday" => "1",
                  "friday" => "1",
                  "saturday" => "1",
                  "id" => bag.id.to_s
                }
              }
            }

            expect(regime.bags.count).to eq(2)
            result = described_class.new(regime).call(by: user, params: params)

            new_regime = result.object
            expect(new_regime.bags.count).to eq(1)
            expect(regime.reload.bags.count).to eq(2)

            expect(Regime.count).to eq(regime_count + 1)
            expect(RegimeBag.count).to eq(bag_count + 1)
          end
        end

        context "when there are changes to the regime" do
          let(:params) { { add_hd: true } }

          it "creates a new regime" do
            command = described_class.new(regime)
            expect { command.call(by: user, params: params) }.to change(Regime, :count).by(1)
          end

          it "the new regime is not the original regime" do
            new_regime = described_class.new(regime).call(by: user, params: params).object
            expect(new_regime).to be_present
            expect(new_regime.id).to be_present
            expect(new_regime.id).not_to eq(regime.id)
          end

          it "the new regime's bags are not those of the original" do
            result = described_class.new(regime).call(by: user, params: params)
            new_regime = result.object
            original_bag_ids = regime.bags.map(&:id)
            new_bag_ids = new_regime.bags.map(&:id)
            expect(original_bag_ids - new_bag_ids).to eq(original_bag_ids)
          end
        end
      end
    end
  end
end
