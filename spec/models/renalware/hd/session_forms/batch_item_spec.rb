# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    module SessionForms
      describe BatchItem, type: :model do
        it { is_expected.to belong_to :batch }

        describe "#status" do
          it "defaults to queued" do
            expect(described_class.new).to have_attributes(
              queued?: true,
              compiled?: false
            )
          end
        end
      end
    end
  end
end
