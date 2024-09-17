# frozen_string_literal: true

module CoreExtensions
  describe Ox::ElementAdditions do
    describe "<<()" do
      it "allows a null node to be supplied in which case it just returns self" do
        elem = ::Ox::Element.new("MyElement")
        elem << "test"
        elem << nil
        expect(elem.nodes.length).to eq(1)
      end
    end
  end
end
