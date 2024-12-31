module Renalware
  module PD
    describe APDRegime do
      subject(:regime) { described_class.new }

      describe "validations" do
        it do
          aggregate_failures do
            is_expected.to validate_numericality_of(:last_fill_volume)
            is_expected.to validate_numericality_of(:dwell_time)
            is_expected.to validate_numericality_of(:additional_manual_exchange_volume)
          end
        end

        it do
          regime.tidal_indicator = true
          expect(regime).to validate_numericality_of(:tidal_percentage)
        end

        it do
          aggregate_failures do
            is_expected.to validate_numericality_of(:no_cycles_per_apd)
            is_expected.to validate_numericality_of(:overnight_volume)
            is_expected.to validate_numericality_of(:daily_volume)
            is_expected.to validate_numericality_of(:therapy_time)
            is_expected.to validate_numericality_of(:fill_volume)
            is_expected.to validate_presence_of(:fill_volume)
            is_expected.to validate_presence_of(:no_cycles_per_apd)
          end
        end

        describe "#additional_manual_exchange_volume" do
          context "when regime has an additional_manual_exchange bag" do
            it "requires additional_manual_exchange_volume to be specified" do
              allow(regime).to receive(:has_additional_manual_exchange_bag?).and_return(true)
              regime.additional_manual_exchange_volume = nil

              expect(regime).to validate_presence_of :additional_manual_exchange_volume
            end
          end

          context "when regime does not have an additional_manual_exchange bag" do
            it "does not expect additional_manual_exchange_volume to be specified" do
              allow(regime).to receive(:has_additional_manual_exchange_bag?).and_return(false)
              regime.additional_manual_exchange_volume = nil

              expect(regime).not_to validate_presence_of :additional_manual_exchange_volume
            end
          end
        end

        describe "#last_fill_volume" do
          context "when regime has a last_fill bag" do
            it "requires last_fill_volume to be specified" do
              allow(regime).to receive(:has_last_fill_bag?).and_return(true)
              regime.last_fill_volume = nil

              expect(regime).to validate_presence_of :last_fill_volume
            end
          end

          context "when regime does not have a last_fill bag" do
            it "does not expect last_fill_volume to be specified" do
              allow(regime).to receive(:has_last_fill_bag?).and_return(false)
              regime.last_fill_volume = nil

              expect(regime).not_to validate_presence_of :last_fill_volume
            end
          end
        end

        describe "#tidal_percentage" do
          it "validates #tidal_percentage when the regime is tidal" do
            regime.tidal_indicator = true
            expect(regime).to validate_presence_of :tidal_percentage
          end

          it "doesn't validate #tidal_percentage when the regime is not tidal" do
            regime.tidal_indicator = false
            expect(regime).not_to validate_presence_of :tidal_percentage
          end
        end

        def has_numeric_validation(attribute, range)
          regime.send(:"#{attribute}=", range.first - 1)
          regime.valid?
          expected_message = t(
            "errors.messages.numeric_inclusion",
            from: range.first,
            to: range.last
          )
          regime.errors[attribute].include?(expected_message)

          # clear errors and do with range.last?
        end

        it "tidal_percentage validates numeric_inclusion" do
          regime.tidal_indicator = true
          expect(
            has_numeric_validation(:tidal_percentage,
                                   APDRegime::VALID_RANGES.tidal_percentages)
          ).to be(true)
        end

        it "no_cycles_per_apd validates numeric_inclusion" do
          expect(
            has_numeric_validation(:no_cycles_per_apd,
                                   APDRegime::VALID_RANGES.cycles_per_apd)
          ).to be(true)
        end

        it "overnight_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:overnight_volume, APDRegime::VALID_RANGES.overnight_volumes)
          ).to be(true)
        end

        it "dwell_time validates numeric_inclusion" do
          expect(
            has_numeric_validation(:dwell_time, APDRegime::VALID_RANGES.dwell_times)
          ).to be(true)
        end

        it "fill_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:fill_volume,
                                   APDRegime::VALID_RANGES.fill_volumes)
          ).to be(true)
        end

        it "therapy_time validates numeric_inclusion" do
          expect(
            has_numeric_validation(:therapy_time,
                                   APDRegime::VALID_RANGES.therapy_times)
          ).to be(true)
        end

        it "last_fill_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:last_fill_volume,
                                   APDRegime::VALID_RANGES.last_fill_volumes)
          ).to be(true)
        end

        it "additional_manual_exchange_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:additional_manual_exchange_volume,
                                   APDRegime::VALID_RANGES.additional_manual_exchange_volumes)
          ).to be(true)
        end
      end

      describe "#has_additional_manual_exchange_bag?" do
        it "returns true if at least one bag is an additional_manual_exchange" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).to have_additional_manual_exchange_bag
        end

        it "returns false if no bags are an additional_manual_exchange" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)
          regime.bags << build(:pd_regime_bag, role: :last_fill)

          expect(regime).not_to have_additional_manual_exchange_bag
        end
      end

      describe "#has_last_fill_bag?" do
        it "returns true if at least one bag has the last fill role" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :last_fill)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).to have_last_fill_bag
        end

        it "returns false if no bags ave the last_fill role" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).not_to have_last_fill_bag
        end
      end

      describe "callbacks" do
        it "calculates overnight volume before_save" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)
          expect_any_instance_of(APD::CalculateVolumes).to receive(:call)

          regime.save!

          expect(regime.overnight_volume).to be > 0
        end
      end
    end
  end
end
