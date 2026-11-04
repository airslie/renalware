require "rails_helper"
require "pdf/reader"
require "tempfile"

describe WickedPdf do
  def pdf_text(html)
    pdf = WickedPdf.new.pdf_from_string(html, encoding: "UTF-8")
    PDF::Reader.new(StringIO.new(pdf)).pages.map(&:text).join("\n")
  end

  it "explicitly disables local file access rather than relying on the wkhtmltopdf default" do
    expect(described_class.config[:disable_local_file_access]).to be(true)
  end

  it "renders ordinary HTML" do
    text = pdf_text("<html><body><p>Hello renal unit</p></body></html>")

    expect(text).to include("Hello renal unit")
  end

  it "does not read local files referenced from the HTML" do
    secret = Tempfile.new(["secret", ".html"])
    secret.write("<html><body>LOCALFILEMARKER</body></html>")
    secret.close

    text = pdf_text(<<~HTML)
      <html><body>
        <p>Before</p>
        <iframe src="file://#{secret.path}" width="500" height="200"></iframe>
      </body></html>
    HTML

    expect(text).to include("Before")
    expect(text).not_to include("LOCALFILEMARKER")
  ensure
    secret&.unlink
  end
end
