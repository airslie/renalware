module World
  module PD::APDRegime
    module Domain
      def build_apd_regime_for(patient:, user:, data:)
        regime = Renalware::PD::APDRegime.new(patient: patient)
        data.each do |key, value|
          regime.public_send(:"#{key.to_sym}=", value)
        end
        regime.treatment ||= "A treatment"
        regime
      end

      def add_bags_to_regime(regime:, user:, data:)
        data.each do |attrs|
          bag = regime.bags.new
          bag.bag_type = bag_type_with_glucose_strength(attrs[:glucose_strength])
          bag.role = attrs[:role].to_sym
          bag.volume = attrs[:volume]
          reset_all_days_to_false_for(bag: bag)
          set_selected_days_to_true_for_bag(bag: bag, comma_delimited_days_string: attrs[:days])
        end
        regime.save!
      end

      def expect_calculated_regime_volumes_to_be(data:, regime:)
        regime.save!
        data.each do |key, value|
          expect(regime.public_send(key.to_sym).to_s).to eq(value)
        end
      end

      private

      def reset_all_days_to_false_for(bag:)
        Date::DAYNAME_SYMBOLS.map do |day|
          bag.public_send(:"#{day}=", false)
        end
      end

      def set_selected_days_to_true_for_bag(bag:, comma_delimited_days_string:)
        days = comma_delimited_days_string.split(",")
        days.each do |day|
          bag.public_send(:"#{day}=", true)
        end
        expect(bag.days_per_week).to eq(days.length)
      end

      def bag_type_with_glucose_strength(strength)
        Renalware::PD::BagType.find_by!(glucose_strength: strength)
      end
    end

    module Web
      include Domain

      # WIP
      # def build_apd_regime_for(patient:, user:, data:)
      #   data = data.to_h
      #   login_as user
      #   visit new_patient_pd_apd_regime_path(patient)
      #   fill_in "* Start date", with: data["start_date"]
      #   select("APD Wet Day", from: "Treatment")
      #   fill_in("* Cycles per session", with: data["cycles"])
      #   fill_in("* Fill volume (ml)", with: data["fill_volume"])
      #   fill_in("Last fill volume (ml)", with: data["last_fill_volume"])
      #   fill_in("Add'l man exchange vol (ml)", with: data["additional_manual_exchange_volume"])
      # end

      # WIP
      # def add_bags_to_regime(regime:, user:, data:)
      #   data.each do |attrs|
      #     find("a.add-bag").click && wait_for_ajax
      #      within(".fields:last-child") do
      #        select attrs["volume"], from: "Volume (ml)"
      #        select attrs["name"], from: "* Bag type"
      #      end
      #   end
      # end
    end
  end
end
