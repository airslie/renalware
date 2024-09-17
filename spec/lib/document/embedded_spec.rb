# frozen_string_literal: true

module Document
  describe Embedded, type: :lib do
    include TranslationsHelper

    before do
      @klass = Class.new(Document::Embedded) do
        def self.name
          "Document::Foo"
        end

        attribute :codes
      end
    end

    describe ".attribute" do
      context "with Enum type" do
        context "with given enums" do
          before do
            @klass.attribute :codes, Enum, enums: %i(one two three)
          end

          it "gets the enum values from the option :enums" do
            expect(@klass.codes.values).to eq(%i(one two three))
          end
        end

        context "without given enums" do
          # rubocop:disable Naming/HeredocDelimiterNaming
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
          # rubocop:enable Naming/HeredocDelimiterNaming

          before do
            with_translations(:"en-GB", translations) do
              @klass.attribute :codes, Enum
            end
          end

          it "gets the enum values from I18n" do
            expect(@klass.codes.values).to eq(%i(one two three))
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
            attribute :nested, Nested
          end
        end

        let(:instance) { @klass.new }

        it "adds validation on the nested model" do
          allow(instance).to receive(:nested_valid)

          instance.valid?

          expect(instance).to have_received(:nested_valid)
        end

        it "adds a default value" do
          expect(instance.nested).to be_a(Nested)
        end

        context "with default value" do
          before do
            @klass.attribute :nested, Nested, default: Nested.new(value: 1)
          end

          it "keeps the default value given" do
            expect(instance.nested.value).to eq(1)
          end
        end
      end
    end
  end
end
