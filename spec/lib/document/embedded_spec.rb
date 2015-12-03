require "rails_helper"
require "document/enum"

module Document
  describe Embedded, type: :lib do
    include TranslationsHelper

    before do
      @klass = Class.new(Document::Embedded) do
        def self.name
          "Document::Foo"
        end
      end
    end

    describe ".attribute" do
      context "with Enum type" do
        context "with given enums" do
          it "gets the enum values from the option :enums" do
            @klass.attribute :codes, Enum, enums: %i(one two three)
            expect(@klass.codes.values).to eq(%i(one two three))
          end
        end

        context "without given enums" do
          let(:translations) do
            Psych.load(<<-EOF)
              enumerize:
                document/foo:
                  codes:
                    one: one
                    two: two
                    three: three
            EOF
          end

          it "gets the enum values from I18n" do
            with_translations(:"en-GB", translations) do
              @klass.attribute :codes, Enum
              expect(@klass.codes.values).to eq(%i(one two three))
            end
          end
        end
      end

      context "with nested attribute" do
        before do
          @klass = Class.new(Document::Embedded) do
            def self.name
              "Document::Foo"
            end

            class Nested < Document::Embedded
              attribute :value
            end
          end
        end

        let(:instance) { @klass.new }

        it "adds validation on the nested model" do
          @klass.attribute :nested, Nested

          expect(instance).to receive(:nested_valid)
          instance.valid?
        end

        context "with default value" do
          it "adds a default value" do
            @klass.attribute :nested, Nested

            expect(instance.nested).to be_a(Nested)
          end

          it "keeps the default value given" do
            @klass.attribute :nested, Nested, default: Nested.new(value: 1)

            expect(instance.nested.value).to eq(1)
          end
        end
      end
    end
  end
end
