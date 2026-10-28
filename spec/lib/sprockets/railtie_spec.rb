describe Sprockets::Railtie do
  let(:environment) do
    described_class.build_environment(Rails.application).tap do |assets|
      assets.cache = Sprockets::Cache::MemoryStore.new
    end
  end

  it "compiles the core stylesheet including globbed Sass partials" do
    css = environment.find_asset("renalware/core.css").to_s

    expect(css).to include("span.no-permission")
    expect(css).not_to include("$disabled-colour")
  end

  it "resolves image URLs for the watermark" do
    css = environment.find_asset("renalware/watermark.css").to_s

    expect(css).to match(%r{/assets/renalware/draft-[a-f0-9]+\.jpg})
    expect(css).not_to include("image-url(")
  end

  it "embeds the draft image in PDF styles" do
    css = environment.find_asset("renalware/pdf.css").to_s

    expect(css).to include("data:image/jpeg;base64,")
    expect(css).not_to include("asset-data-url(")
  end
end
