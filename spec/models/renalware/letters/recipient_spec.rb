# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Recipient do
      it :aggregate_failures do
        is_expected.to respond_to(:emailed_at)
        is_expected.to respond_to(:printed_at)
      end

      describe "#addressee_id" do
        describe "validation" do
          it "validates presence if person is a contact" do
            recipient = described_class.new(person_role: "contact")
            expect(recipient).to validate_presence_of(:addressee_id)
          end

          it "validates presence of person_role" do
            recipient = described_class.new(person_role: nil)

            recipient.save

            expect(recipient.errors[:base]).to include("Please select a main recipient")
          end
        end
      end
    end
  end
end
