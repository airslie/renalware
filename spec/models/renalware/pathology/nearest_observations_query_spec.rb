# frozen_string_literal: true

module Renalware::Pathology
  describe NearestObservationsQuery do
    include PathologySpecHelper

    subject {
      described_class.new(
        patient: patient,
        date: date,
        code_group: code_group,
        look_behind_days: look_behind_days
      ).call.sort_by { |hsh| hsh[:code] }
    }

    let(:user) { create(:user) }
    let(:look_behind_days) { 1 }
    let(:date) { Date.current }
    let(:patient) { create(:pathology_patient) }
    let(:code_group) do
      create(:pathology_code_group).tap do |grp|
        %w(HGB PLT).each do |code|
          create(
            :pathology_code_group_membership,
            code_group: grp,
            observation_description: create(:pathology_observation_description, code: code),
            by: user
          )
        end
      end
    end

    describe "#call" do
      context "when patient has no path" do
        it { is_expected.to eq([]) }
      end

      context "when patient no but its before (date - look_behind_days)" do
        before {
          create_observations(
            patient,
            code_group.observation_descriptions,
            observed_at: date - (look_behind_days + 1).days,
            result: 1
          )
        }

        it { is_expected.to eq([]) }
      end

      context "when patient has path just on the target date" do
        before {
          create_observations(
            patient,
            code_group.observation_descriptions,
            observed_at: date,
            result: 1
          )
        }

        it do
          is_expected.to eq(
            [
              { code: "HGB", observed_on: date, result: "1" },
              { code: "PLT", observed_on: date, result: "1" }
            ]
          )
        end
      end

      context "when patient has path just within the look behind period" do
        before {
          create_observations(
            patient,
            code_group.observation_descriptions,
            observed_at: date - look_behind_days.days,
            result: 1
          )
        }

        it do
          is_expected.to eq(
            [
              { code: "HGB", observed_on: date - look_behind_days.days, result: "1" },
              { code: "PLT", observed_on: date - look_behind_days.days, result: "1" }
            ]
          )
        end
      end
    end
  end
end
