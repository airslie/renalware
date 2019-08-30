# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Lists::Form do
      context "when named_filter is :all" do
        subject(:form) { described_class.new(named_filter: :all, params: params) }

        let(:params) { {} }

        describe "#letter_state_options" do
          subject { form.letter_state_options }

          it do
            is_expected.to eq(
              [
                ["Draft", :draft],
                ["Pending Review", :pending_review],
                ["Approved (Ready to Print)", :approved],
                ["Completed (Printed)", :completed]
              ]
            )
          end
        end

        describe "#attributes" do
          let(:params) do
            {
              enclosures_present: true,
              state_eq: 1,
              author_id_eq: 2,
              created_by_id_eq: 3,
              letterhead_id_eq: 4,
              page_count_in_array: 5
            }
          end

          it "maps the supplied parms hash to Virtus attributes" do
            expect(form).to have_attributes(params)
          end
        end
      end

      context "when named_filter is :batch_printable" do
        subject(:form) { described_class.new(named_filter: :batch_printable) }

        describe "#letter_state_options" do
          subject { form.letter_state_options }

          it do
            is_expected.to eq(
              [
                ["Approved (Ready to Print)", :approved]
              ]
            )
          end
        end
      end
    end
  end
end
