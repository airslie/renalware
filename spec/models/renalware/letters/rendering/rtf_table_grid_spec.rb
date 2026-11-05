module Renalware
  module Letters::Rendering
    describe RTFTableGrid do
      def grid(html)
        described_class.new(Nokogiri::HTML.fragment(html).at_css("table"))
      end

      def cell_text(row)
        row[:cells].map { |cell| cell&.text }
      end

      before { stub_const("#{described_class}::MAX_CELLS", 6) }

      it "allows the exact expanded rectangle limit and retains span positions" do
        result = grid(<<~HTML).call
          <table><tr><td rowspan="2">A</td><td colspan="2">B</td></tr>
          <tr><td>C</td><td>D</td></tr></table>
        HTML

        expect(result.map { |row| cell_text(row) })
          .to eq([["A", "B", nil], [nil, "C", "D"]])
      end

      it "rejects sparse tables whose padded output rectangle exceeds the limit" do
        table = grid(<<~HTML)
          <table><tr><td colspan="4">Wide</td></tr><tr><td>Narrow</td></tr></table>
        HTML

        expect { table.call }
          .to raise_error(described_class::TableTooLargeError, /6 expanded cells/)
      end

      it "rejects excessive row counts before allocating the grid" do
        table = grid("<table>#{'<tr><td>A</td></tr>' * 7}</table>")

        expect { table.call }.to raise_error(described_class::TableTooLargeError)
      end

      it "limits row spans to actual rows rather than reserving phantom rows" do
        result = grid('<table><tr><td rowspan="100" colspan="6">A</td></tr></table>').call

        expect(result.size).to eq(1)
        expect(result.first[:cells].map { |cell| cell&.text }).to eq(["A", nil, nil, nil, nil, nil])
      end

      it "rejects cumulative spans before expanding the over-limit cell" do
        table = grid('<table><tr><td colspan="4">A</td><td colspan="4">B</td></tr></table>')

        expect { table.call }.to raise_error(described_class::TableTooLargeError)
      end

      it "propagates the size error through the HTML renderer instead of truncating content" do
        html = '<p>Before</p><table><tr><td colspan="7">Content</td></tr></table><p>After</p>'

        expect { HtmlToRTF.new(html).call }.to raise_error(described_class::TableTooLargeError)
      end
    end
  end
end
