module Renalware
  describe "Ordered Set scope" do # rubocop:disable RSpec/DescribeClass
    before do
      @klass = Class.new(ApplicationRecord) do
        self.table_name = "quxes"
        include OrderedSetScope
      end

      @klass.reset_column_information
    end

    describe "#ordered_set" do
      before do
        create_relation

        %w(baz bar foo).each do |value|
          @klass.create(code: value)
        end
      end

      context "when the specified values are present in the relation" do
        let(:ordered_values) { %w(foo bar) }

        it "returns an ordered scope with the attribute and values specified" do
          attribute = :code
          actual_scope = @klass.ordered_set(attribute, ordered_values)

          expect(actual_scope).to be_a ActiveRecord::Relation
          expect(actual_scope.map(&:code)).to eq(ordered_values)
        end
      end

      context "when the values are not present in the relation for the specified attribute" do
        let(:ordered_values) { ["foo", "::does not exists::", "bar"] }

        it "returns an ordered scope with the values that exist in the relation" do
          attribute = :code
          actual_scope = @klass.ordered_set(attribute, ordered_values)

          expect(actual_scope).to be_a ActiveRecord::Relation
          expect(actual_scope.map(&:code)).to eq(%w(foo bar))
        end
      end
    end

    def create_relation
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :quxes, force: true do |t|
          t.string :code
        end
      end
    end
  end
end
