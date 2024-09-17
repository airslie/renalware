# frozen_string_literal: true

module Renalware
  describe Patients::WorryPresenter do
    [
      {
        category_name: "cat1",
        notes: "012345789012345789012345789012345789",
        truncate_at: 30,
        expectation: "Yes (cat1) 0123457890123457..."
      },
      {
        category_name: "cat1",
        notes: "012345789012345789012345789012345789",
        expectation: "Yes (cat1) 0123457890123457..."
      },
      {
        category_name: "cat1",
        notes: "012345789012345789012345789012345789",
        truncate_at: 20,
        expectation: "Yes (cat1) 012345..."
      },
      {
        category_name: "cat1",
        notes: "012",
        truncate_at: 30,
        expectation: "Yes (cat1) 012"
      },
      {
        category_name: "cat1",
        notes: nil,
        expectation: "Yes (cat1)"
      },
      {
        category_name: nil,
        notes: nil,
        expectation: "Yes"
      },
      {
        category_name: nil,
        notes: nil,
        expectation: "No",
        worry_nil: false
      }
    ].each do |args|
      it do
        category = if (cat_name = args[:category_name])
                     Patients::WorryCategory.new(name: cat_name)
                   end
        worry = unless args[:worry_nil] == false
                  Patients::Worry.new(worry_category: category, notes: args[:notes])
                end
        opts = {}
        opts[:truncate_at] = args[:truncate_at] if args.key?(:truncate_at)

        expect(
          described_class.new(worry).summary(**opts)
        ).to eq(args[:expectation])
      end
    end
  end
end
