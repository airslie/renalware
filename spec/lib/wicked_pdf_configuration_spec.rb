require "rails_helper"
require "pdf/reader"
require "socket"
require "tempfile"

describe WickedPdf do
  def pdf_text(html, **options)
    pdf = WickedPdf.new.pdf_from_string(html, { encoding: "UTF-8" }.merge(options))
    PDF::Reader.new(StringIO.new(pdf)).pages.map(&:text).join("\n")
  end

  def record_requests(server, requests)
    loop do
      client = server.accept
      requests << client.readpartial(4096)
      client.close
    end
  rescue IOError
    nil
  end

  def with_local_http_server
    server = TCPServer.new("127.0.0.1", 0)
    requests = Queue.new
    listener = Thread.new { record_requests(server, requests) }
    yield server.addr[1], requests
  ensure
    server&.close
    listener&.join(1)
  end

  it "explicitly disables local file access rather than relying on the wkhtmltopdf default" do
    expect(described_class.config[:disable_local_file_access]).to be(true)
  end

  it "disables JavaScript" do
    expect(described_class.config[:disable_javascript]).to be(true)
  end

  it "routes any network fetch through a proxy that nothing listens on" do
    expect(described_class.config[:proxy]).to eq("http://127.0.0.1:9")
  end

  it "renders ordinary HTML" do
    text = pdf_text("<html><body><p>Hello renal unit</p></body></html>")

    expect(text).to include("Hello renal unit")
  end

  it "still renders footer page numbers" do
    two_pages = <<~HTML
      <html><body>
        <p>First</p><div style="page-break-after: always"></div><p>Second</p>
      </body></html>
    HTML

    text = pdf_text(two_pages, footer: { right: "Page [page] of [topage]" })

    expect(text).to include("Page 1 of 2")
  end

  it "does not run JavaScript in the HTML" do
    text = pdf_text(<<~HTML)
      <html><body>
        <p id="target">Static</p>
        <script>document.getElementById("target").textContent = "SCRIPTRAN";</script>
      </body></html>
    HTML

    expect(text).to include("Static")
    expect(text).not_to include("SCRIPTRAN")
  end

  it "does not make network requests for resources referenced from the HTML" do
    with_local_http_server do |port, requests|
      pdf_text(<<~HTML)
        <html><body>
          <p>Before</p>
          <img src="http://127.0.0.1:#{port}/probe.png">
          <link rel="stylesheet" href="http://127.0.0.1:#{port}/probe.css">
        </body></html>
      HTML

      expect(requests).to be_empty
    end
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
