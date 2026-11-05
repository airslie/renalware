module Renalware
  module Letters::Rendering
    describe RTFRenderer do
      let(:letter) { instance_double(Letters::LetterPresenter, to_html: "<p>Letter</p>") }

      it "keeps Pandoc available when the experimental setting is disabled" do
        allow(Renalware.config).to receive(:letters_render_rtf_with_ruby).and_return(false)
        converter = instance_double(PandocRuby)
        allow(PandocRuby).to receive(:html).and_return(converter)
        allow(converter).to receive(:to_rtf).with("--eol=crlf").and_return("Pandoc output")

        expect(described_class.new(letter).call).to eq("Pandoc output")
      end

      it "uses archived HTML through the existing factory without invoking Pandoc" do
        allow(Renalware.config).to receive(:letters_render_rtf_with_ruby).and_return(true)
        archive = instance_double(Letters::Archive, content: "<p>Historical café</p>")
        archived_letter = instance_double(Letters::Letter, archived?: true, archive:)
        presenter = Letters::LetterPresenter.new(archived_letter)
        allow(PandocRuby).to receive(:html).and_raise("Pandoc must not run")

        result = Letters::RendererFactory.renderer_for(presenter, :rtf).call

        expect(result).to include('Historical caf\u233?')
        expect(result).not_to match(/(?<!\r)\n/)
        expect(archive.content).to eq("<p>Historical café</p>")
      end
    end
  end
end
