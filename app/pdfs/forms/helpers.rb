# frozen_string_literal: true

require "tempfile"

module Forms::Helpers
  def render_and_open(prawn_pdf_doc)
    filename = File.join(Dir.pwd, "./tmp", "#{Time.now.to_i}.pdf")
    prawn_pdf_doc.render_file filename
    open_pdf filename
  end

  def open_pdf(filename)
    # Open the test file in ubuntu - just use "open" if mac?
    # You may need to fo
    # `sudo apt-get install appmenu-gtk2-module appmenu-gtk3-module`

    `gio open #{filename}`
  rescue StandardError
    nil
  end
end
