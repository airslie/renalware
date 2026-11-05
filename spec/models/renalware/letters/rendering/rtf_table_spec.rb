module Renalware
  module Letters::Rendering
    describe RTFTable do
      def convert(html)
        HtmlToRTF.new(html).call
      end

      fixtures = JSON.parse(File.read("spec/fixtures/letters/rtf/pandoc_tables.json"))
      fixtures.fetch("cases").each do |fixture|
        it "matches Pandoc table output for #{fixture.fetch('name')}" do
          result = convert(fixture.fetch("html")).gsub("\r\n", "\n")
          body = result.split("\n", 2).last.rpartition("}").first.strip

          expect(body).to eq(fixture.fetch("body"))
        end
      end

      it "preserves Unicode, escapes RTF syntax and retains CRLF inside cells" do
        result = convert("<table><tr><td>{dose} café ≥ 😀</td><td>5 mg</td></tr></table>")

        expect(result).to include('\{dose\} caf\u233? \u8805? \u-10179?\u-8704?')
        expect(result).not_to match(/(?<!\r)\n|\r(?!\n)/)
      end

      it "flattens nested tables without creating invalid nested RTF rows" do
        result = convert(<<~HTML)
          <table><tr><td>Before<table><tr><td>Nested</td><td>Value</td></tr></table>After</td></tr></table>
        HTML

        expect(result.scan('\trowd').size).to eq(1)
        expect(result).to include('Before\par}', 'Nested\tab Value\tab', 'After\par}')
      end

      it "ignores empty tables and preserves the surrounding text" do
        result = convert("<p>Before</p><table></table><p>After</p>")

        expect(result.scan('\par}').size).to eq(2)
        expect(result).not_to include('\trowd')
      end

      it "uses equal widths for incomplete or invalid column percentages" do
        result = convert(<<~HTML)
          <table><colgroup><col style="width: 0%"></colgroup>
          <tr><td>A</td><td>B</td></tr></table>
        HTML

        expect(result).to include('\cellx4320\cellx8640')
      end
    end
  end
end
