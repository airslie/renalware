module Renalware
  describe Letters::PathologyLayout do
    subject(:layout) { described_class.new }

    describe "#each_group" do
      it "yields a block for each group of path description that should be displayed in a letter" do
        da = build_stubbed(
          :pathology_observation_description, letter_group: 1, letter_order: 1, code: "A"
        )
        db = build_stubbed(
          :pathology_observation_description, letter_group: 1, letter_order: 2, code: "B"
        )
        dc = build_stubbed(
          :pathology_observation_description, letter_group: 2, letter_order: 1, code: "C"
        )

        layout.each_group do |group_number, descriptions|
          expect(descriptions).to eq([da, db]) if group_number == 1
          expect(descriptions).to eq([dc]) if group_number == 2
        end
      end
    end
  end
end
