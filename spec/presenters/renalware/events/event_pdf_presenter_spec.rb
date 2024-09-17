# frozen_string_literal: true

describe Renalware::Events::EventPdfPresenter do
  subject(:presenter) { described_class.new(event) }

  let(:event) { build_stubbed(:simple_event) }
  let(:centre_code) { "ABC" }
  let(:centre) do
    create(
      :hospital_centre,
      code: centre_code,
      info: "Info",
      trust_name: "Some Hospital",
      trust_caption: "NHS Trust"
    )
  end

  def change_config_ukrdc_site_code(code)
    old_code = Renalware.config.ukrdc_site_code
    Renalware.config.ukrdc_site_code = code
    yield if block_given?
    Renalware.config.ukrdc_site_code = old_code
  end

  describe "delegation to hospital_centre" do
    around do |example|
      change_config_ukrdc_site_code(centre.code) do
        example.run
      end
    end

    describe "#hospital_centre_info" do
      subject(:info) { presenter.hospital_centre_info }

      it { is_expected.to eq(centre.info) }

      context "when no Hospitals::Centre exists with code specified in config.ukrdc_site_code" do
        it "raises an error" do
          change_config_ukrdc_site_code("NOEXIST") do
            expect { info }.to raise_error(
              Renalware::Events::EventPdfPresenter::DefaultHospitalCentreNotFoundError
            )
          end
        end
      end

      context "when config.ukrdc_site_code is not set" do
        it "raises an error" do
          change_config_ukrdc_site_code("") do
            expect { info }.to raise_error(
              Renalware::Events::EventPdfPresenter::DefaultHospitalCentreNotSetError
            )
          end
        end
      end
    end

    describe "#hospital_centre_trust_name" do
      subject { presenter.hospital_centre_trust_name }

      it { is_expected.to eq(centre.trust_name) }
    end

    describe "#hospital_centre_trust_caption" do
      subject { presenter.hospital_centre_trust_caption }

      it { is_expected.to eq(centre.trust_caption) }
    end
  end
end
