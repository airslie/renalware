The idea here is that eventually we will have, say, 4 formats: html, pdf, rtf, fhir
and the first three 'presentation' formats will render the document in exactly the same way, so
you should see visually the same result regardless of html/pdf/rtf/other.
This structure allows us to possibly use the same DSL for presentational formats, to ensure that all
parts of the document are included; using phlex for the html version would help us achieve this.
We should probably avoid the view-component 'mini-controller' approach of allowing the component to
query for data, and instead either pass down a repository object or presenter, as data consistency
between presentation formats is essential.

## Experimental Ruby RTF renderer

Pandoc remains the default. Set `LETTERS_RENDER_RTF_WITH_RUBY=true` before boot,
or configure `letters_render_rtf_with_ruby = true`, to use the experimental
Nokogiri/pure Ruby writer through the existing RTF renderer. This affects RTF
downloads, filesystem exports and HL7 documents; enable only after comparison.
Unset the environment variable (and restart) to return to Pandoc.

Both paths consume `LetterPresenter#to_html`, which uses archived HTML for archived
letters. The Ruby path does not regenerate historical content from current records.
It emits CRLF line endings, escapes RTF syntax and encodes Unicode as UTF-16 RTF
escapes. It does not launch a subprocess, create temporary files or fetch resources.

The prototype supports paragraphs, headings, inline emphasis, line breaks, basic
lists, preformatted text and links rendered as text with URLs. Tables use native RTF rows and cells,
a six-inch width, equal columns by default,
percentage widths from `col` styles, cell alignment, header bottom borders and
multiline cell content. Captions appear below the table. Row and column spans expand
into blank grid cells, matching Pandoc's RTF output; span values are capped at 100 and row spans stop at the final actual row.
The expanded rectangle (row count × widest row) is limited to 10,000 cells,
including padding. Oversized tables raise `RTFTableGrid::TableTooLargeError`
before further grid expansion; content is not silently truncated.
Nested tables are flattened inside the containing cell. CSS table styling, merged
cells and explicit pixel widths are not supported. CSS, images, SVG, embedded resources,
advanced numbering and page layout are not reproduced. Basic nested lists use
indented paragraphs. Paragraph spacing, body font size and heading sizes follow
Pandoc, without adding empty paragraphs for structural HTML containers. Unknown
containers retain their text. This is not yet a fidelity-equivalent replacement.

To compare the same synthetic HTML in a development console while Pandoc remains
the configured default:

```ruby
html = '<h2>Example</h2><p>Dose: <strong>5 mg</strong> — café</p>'
source = Struct.new(:to_html).new(html)
pandoc = Renalware::Letters::Rendering::RTFRenderer.new(source).call
ruby = Renalware::Letters::Rendering::HtmlToRTF.new(html).call
File.binwrite(Rails.root.join("tmp/pandoc-example.rtf"), pandoc)
File.binwrite(Rails.root.join("tmp/ruby-example.rtf"), ruby)
```

For representative comparisons, use synthetic or appropriately de-identified letter
HTML, including historical templates. Check clinical text, Unicode, paragraphs,
lists, tables and CRLF compatibility in the actual receiving application before
changing the default. Keep exports containing patient information in approved storage.
