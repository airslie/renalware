# From https://github.com/rubysherpas/paranoia/wiki/Testing-with-rspec
shared_examples_for "a not yet implemented ToC section" do
  it "is not yet implemented" do
    component = described_class.new(nil)

    expect(component.render?).to be(false)
    expect { component.call }.to raise_error(NotImplementedError)
  end
end
