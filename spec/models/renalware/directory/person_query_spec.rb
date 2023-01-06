# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Directory
    describe PersonQuery do
      describe "#call" do
        before do
          nurse = create(:user)
          create(:directory_person, given_name: "Yosemite", family_name: "Sam", by: nurse)
          create(:directory_person, family_name: "::another patient::", by: nurse)
        end

        context "with no filters" do
          it "returns all people" do
            expect(PersonQuery.new.call.count).to eq(2)
          end
        end

        context "with a given name" do
          it "returns people matching the name" do
            query = PersonQuery.new(q: { name_cont: "Yosemite" }).call
            expect(query.count).to eq(1)
          end
        end

        context "with a family name" do
          it "returns people matching the name" do
            query = PersonQuery.new(q: { name_cont: "Sam" }).call
            expect(query.count).to eq(1)
          end
        end
      end
    end
  end
end
