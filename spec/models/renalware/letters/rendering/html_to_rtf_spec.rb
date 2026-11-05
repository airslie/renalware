module Renalware
  module Letters::Rendering
    describe HtmlToRTF do
      def convert(html)
        described_class.new(html).call
      end

      # Captured from Pandoc using our production template. No Pandoc process is needed
      # to run these parity checks after the original converter is eventually removed.
      fixtures = JSON.parse(File.read("spec/fixtures/letters/rtf/pandoc_paragraphs.json"))
      fixtures.fetch("cases").each do |fixture|
        it "matches Pandoc paragraph output for #{fixture.fetch('name')}" do
          result = convert(fixture.fetch("html")).gsub("\r\n", "\n")
          body = result[result.index('{\pard')..].rpartition("}").first.strip

          expect(body.gsub(/\\line\s*/, '\\line ')).to eq(fixture.fetch("body"))
        end
      end

      it "emits one paragraph per list item without adding paragraphs for list containers" do
        result = convert("<div><ul><li>One</li><li>Two<ul><li>Nested</li></ul>Tail</li></ul></div>")

        expect(result.scan('\par}').size).to eq(4)
        expect(result).to include('\li360 \fi-360', '\li720 \fi-360')
        expect(result).to include('Nested\par}', 'Tail\par}')
      end

      it "matches Pandoc spacing between problems and medication sections" do
        result = convert(<<~HTML)
          <div class="list problems"><b>Problems</b>
            <ul><li>Problem one</li><li>Problem two</li></ul>
          </div>
          <div class="list prescriptions"><b>Current Medications</b>
            <ul><li>Current drug</li></ul>
            <b>Recently Stopped Medications</b><ul><li>Stopped drug</li></ul>
          </div>
        HTML
        paragraphs = result.lines.grep(/\\pard/)

        # Pandoc emits sa180 after each list's final item, and sa0 for earlier items
        # and the subtitle paragraphs. No extra empty paragraphs are required.
        expect(paragraphs.map { |paragraph| paragraph[/\\sa(\d+)/, 1].to_i })
          .to eq([0, 0, 180, 0, 180, 0, 180])
        expect(paragraphs.size).to eq(7)
      end

      it "adds trailing space to ordered and nested lists without changing other items" do
        result = convert("<ol><li>One<ul><li>Nested</li></ul></li><li>Two</li></ol>")
        paragraphs = result.lines.grep(/\\pard/)

        expect(paragraphs.map { |paragraph| paragraph[/\\sa(\d+)/, 1].to_i })
          .to eq([0, 180, 180])
      end

      it "does not create paragraphs for empty lists" do
        result = convert("<ul></ul><ol></ol><p>After</p>")

        expect(result.scan('\par}').size).to eq(1)
      end

      it "matches Pandoc bullet positioning and tab stops at each list level" do
        result = convert("<ul><li>Outer<ul><li>Nested</li></ul></li></ul>")

        expect(result).to include(
          '\li360 \fi-360\ls1\ilvl0\tx360 {\listtext\tab \bullet \tab} Outer',
          '\li720 \fi-360\ls2\ilvl1\tx360 {\listtext\tab \endash \tab} Nested'
        )
      end

      it "retains ordered list numbers and does not leak list controls into following text" do
        result = convert('<ol start="3"><li>First</li><li>Second</li></ol><p>After</p>')

        expect(result).to include('{\listtext\tab 3.\tab} First', '{\listtext\tab 4.\tab} Second')
        expect(result.lines.grep(/After/).first).to include('\li0 \fi0 After')
        expect(result.lines.grep(/After/).first).not_to include('\ls', '\tx', '\listtext')
      end

      it "escapes RTF syntax and encodes Unicode including surrogate pairs" do
        result = convert('<p>{dose} \\ café ≥ 😀</p>')

        expect(result).to include('\\{dose\\} \\\\ caf\u233? \u8805? \u-10179?\u-8704?')
        expect(result).to be_ascii_only
      end

      it "renders semantic formatting, lists, links and table contents" do
        result = convert(<<~HTML)
          <h2>Summary</h2><p><strong>Bold <em>italic</em></strong><br>Next</p>
          <ol start="3"><li>First</li><li>Second<ul><li>Nested</li></ul></li></ol>
          <table><tr><th>Test</th><th>Result</th></tr><tr><td>Hb</td><td>100</td></tr></table>
          <a href="https://example.org">Advice</a>
        HTML

        expect(result).to include('\outlinelevel1 \b \fs32 Summary', '{\b Bold {\i italic}}')
        expect(result).to include('\line Next', '3.\tab} First', '4.\tab} Second')
        expect(result).to include('\endash \tab} Nested', 'Hb\par}', '100\par}', '\cellx4320')
        expect(result).to include("Advice (https://example.org)")
      end

      it "drops resource and executable elements while preserving unknown containers" do
        result = convert(<<~HTML)
          <style>hidden-style</style><script>hidden-script</script>
          <img src="file:///secret"><svg><text>hidden-svg</text></svg>
          <iframe>hidden-frame</iframe><custom>Visible &amp; safe</custom>
          <a href="javascript:bad">Label</a>
        HTML

        expect(result).to include("Visible & safe", "Label")
        expect(result).not_to include("hidden-", "file:///", "javascript:")
      end

      it "preserves preformatted lines and emits only CRLF physical line endings" do
        result = convert("<pre>one\r\ntwo\tthree\nfour</pre>")

        expect(result).to include("one\\line\r\ntwo\\tab three\\line\r\nfour")
        expect(result).not_to match(/(?<!\r)\n|\r(?!\n)/)
        expect(result).to start_with('{\rtf1')
        expect(result).to end_with("}")
      end
    end
  end
end
