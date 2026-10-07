module Renalware
  describe Pathology::CodeGroup do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to have_many(:memberships)
      is_expected.to have_many(:observation_descriptions).through(:memberships)
    end

    describe "uniqueness" do
      subject { described_class.new(name: "A", created_by: user, updated_by: user) }

      let(:user) { create(:user) }

      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe "#descriptions_for_group" do
      context "when supplied group name does not exist" do
        it "returns an empty array" do
          expect(described_class.descriptions_for_group("xyx")).to eq []
        end
      end
    end

    describe "#deletable?" do
      it "is false for the default group and for context specific groups" do
        expect(build(:pathology_code_group, name: "default")).not_to be_deletable
        expect(build(:pathology_code_group, context_specific: true)).not_to be_deletable
        expect(build(:pathology_code_group, context_specific: false)).to be_deletable
      end
    end

    describe "#subgroup_count" do
      it "covers the titles, colours and the highest subgroup in use" do
        group = build(:pathology_code_group, subgroup_titles: %w(A B), subgroup_colours: %w(red))
        group.memberships.build(subgroup: 4, position_within_subgroup: 1)

        expect(group.subgroup_count).to eq 4
      end

      it "is at least 1" do
        expect(described_class.new.subgroup_count).to eq 1
      end
    end

    describe "validating for design" do
      it "requires a title" do
        group = build(:pathology_code_group, title: nil)

        expect(group.valid?(:design)).to be false
        expect(group.errors[:title]).to be_present
      end

      it "rejects an unknown subgroup colour" do
        group = build(:pathology_code_group, title: "T", subgroup_colours: %w(chartreuse))

        expect(group.valid?(:design)).to be false
        expect(group.errors[:subgroup_colours]).to be_present
      end
    end

    describe "saving a group" do
      it "does not cache an empty memberships association" do
        group = create(:pathology_code_group)
        create(:pathology_code_group_membership, code_group: group)

        expect(group.memberships.pluck(:observation_description_id).size).to eq 1
      end
    end

    describe "normalising before validation" do
      it "renumbers positions within each subgroup, preserving order and pads titles/colours" do
        group = build(:pathology_code_group, title: "T", subgroup_titles: [], subgroup_colours: [])
        c = group.memberships.build(subgroup: 2, position_within_subgroup: 9)
        a = group.memberships.build(subgroup: 1, position_within_subgroup: 5)
        b = group.memberships.build(subgroup: 1, position_within_subgroup: 2)

        group.valid?

        expect([b, a, c].map(&:position_within_subgroup)).to eq [1, 2, 1]
        expect(group.subgroup_titles).to eq ["", ""]
        expect(group.subgroup_colours).to eq [nil, nil]
      end

      it "turns blank colours into nil" do
        group = build(:pathology_code_group, title: "T", subgroup_titles: %w(A B),
                                             subgroup_colours: ["", "red"])

        group.valid?

        expect(group.subgroup_colours).to eq [nil, "red"]
      end
    end
  end
end
