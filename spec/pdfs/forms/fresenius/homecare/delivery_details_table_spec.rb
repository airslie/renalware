# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::DeliveryDetailsTable do
  it "generates a PDF" do
    pending "Not finished - Copied from gem repo"
    args = Forms::Homecare::Args.new(**default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    extract_text_from_prawn_doc(doc)

    fail

    # expect(text).to ...
  end
end
