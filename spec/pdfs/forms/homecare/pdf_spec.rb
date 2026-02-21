# frozen_string_literal: true

RSpec.describe Forms::Homecare::Pdf do
  describe "#generate" do
    # describe "argument validation" do
    # it "throws an error if args is nil" do
    #   expect { described_class.generate(nil) }.to raise_error(ArgumentError)
    # end

    # it "throws an error if arg.provider is nil" do
    #   args = Forms::Homecare::Args.new(provider: nil)

    #   expect {
    #     described_class.generate(args)
    #   }.to raise_error(ArgumentError, "Missing provider")
    # end

    # it "throws an error if arg.provider is an empty string" do
    #   args = Forms::Homecare::Args.new(provider: "")

    #   expect {
    #     described_class.generate(args)
    #   }.to raise_error(ArgumentError, "Missing provider")
    # end

    # it "throws an error if arg.version is not a number" do
    #   args = Forms::Homecare::Args.new(provider: :a, version: nil)

    #   expect {
    #     described_class.generate(args)
    #   }.to raise_error(ArgumentError, "Version must be >0")
    # end

    # it "throws an error no matching provider found" do
    #   args = Forms::Homecare::Args.new(provider: :generico, version: 1)

    #   expect {
    #     described_class.generate(args)
    #   }.to raise_error(
    #     ArgumentError,
    #     "No PDF forms found for provider=generico version=1 "\
    #     "trying to resolve Renalwareo::Homecare::V1::Document"
    #   )
    # end

    # it "throws an error no matching version found" do
    #   args = Forms::Homecare::Args.new(provider: :generic, version: 1000)

    #   expect {
    #     described_class.generate(args)
    #   }.to raise_error(
    #     ArgumentError,
    #     "No PDF forms found for provider=generic version=1000 "\
    #     "trying to resolve Homecare::V1000::Document"
    #   )
    # end
    # end

    context "when arguments are valid" do
      it "create render a PDF for a Homecare::Document" do
        args = Forms::Homecare::Args.new(**default_test_arg_values)

        pdf_data = described_class.generate(args).render

        expect(pdf_data).to start_with("%PDF-")
      end
    end
  end
end
