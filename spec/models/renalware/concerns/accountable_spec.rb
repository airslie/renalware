module Renalware
  describe Accountable do # rubocop:disable RSpec/SpecFilePathFormat
    def test_class
      Class.new(ApplicationRecord) do
        include Accountable
        self.table_name = "examples"

        def self.name
          "Example"
        end
      end
    end

    before { create_relation_for_klass }

    let(:created_by_user) { create(:user) }

    describe "#create" do
      context "when the created user is explicity assigned" do
        it "assigns the user who created the record" do
          thing = test_class.create!(created_by: created_by_user, dummy: ":: created it ::")

          expect(thing).to have_attributes(
            created_by: created_by_user,
            updated_by: created_by_user
          )
        end
      end

      context "when the user is implicity assigned" do
        it "assigns the user who created the record" do
          thing = test_class.create!(by: created_by_user, dummy: ":: created it ::")

          expect(thing).to have_attributes(
            created_by: created_by_user,
            updated_by: created_by_user
          )
        end
      end
    end

    describe "#updated_by" do
      let(:updated_by_user) { create(:user) }

      context "when the updated user is explicity assigned" do
        it "assigns the user who updated the record" do
          thing = test_class.create!(created_by: created_by_user, dummy: ":: created it ::")

          thing.update(updated_by: updated_by_user, dummy: ":: updated_it ::")

          expect(thing.updated_by).to eq(updated_by_user)
        end
      end

      context "when the updated user is implicity assigned" do
        it "assigns the user who updated the record" do
          thing = test_class.create!(by: created_by_user, dummy: ":: created it ::")

          thing.update(by: updated_by_user, dummy: ":: updated_it ::")

          expect(thing.updated_by).to eq(updated_by_user)
        end
      end
    end

    def create_relation_for_klass
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :examples, force: true do |t|
          t.string :dummy, null: false
          t.integer :created_by_id, null: false
          t.integer :updated_by_id, null: false
        end
      end
    end
  end
end
