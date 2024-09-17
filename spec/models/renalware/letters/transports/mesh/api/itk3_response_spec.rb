# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe API::ITK3Response do
    include FaradayHelper

    let(:response_code) { "fatal-error" }
    let(:issue_code) { "processing" }
    let(:issue_severity) { "fatal" }
    let(:detail_code) { "10001" }
    let(:detail_description) { "Handling Specification Error" }
    let(:xml) do
      <<-XML
        <!-- Simplified! -->
        <Bundle>
          <entry>
            <resource>
              <MessageHeader>
                <response>
                  <code value="#{response_code}"
                </response>
              </MessageHeader>
            </resource>
          </entry>
          <entry>
            <resource>
              <OperationOutcome>
                <issue>
                  <severity value="#{issue_severity}"/>
                  <code value="#{issue_code}"/>
                  <details>
                    <coding>
                      <code value="#{detail_code}"/>
                      <display value="#{detail_description}"/>
                    </coding>
                  </details>
                </issue>
              </OperationOutcome>
            </resource>
          </entry>
        </Bundle>
      XML
    end
    let(:response) { mock_faraday_response(body: xml, headers: {}) }

    it "raises an error is response headers are empty" do
      expect { described_class.new(response).handleable? }.to raise_error(ArgumentError)
    end

    it do
      itk3_response = described_class.new(response)

      expect(itk3_response.response_code).to eq(response_code)
      expect(itk3_response.issue_code).to eq(issue_code)
      expect(itk3_response.detail_code).to eq(detail_code)
      expect(itk3_response.detail_description).to eq(detail_description)
      expect(itk3_response.issue_severity).to eq(issue_severity)
    end

    describe "infrastructure? and business? predicates which indicate the msg type based on code" do
      [
        ["10001", true, false],
        ["30001", false, true]
      ].each do |arr|
        describe do # rubocop:disable RSpec/MissingExampleGroupArgument
          code, inf, bus = arr
          let(:detail_code) { code }

          it do
            resp = described_class.new(response)

            expect(resp.infrastructure?).to eq(inf)
            expect(resp.business?).to eq(bus)
          end
        end
      end
    end

    describe "infrastructure?" do
      context "when detail_code starts with 1 eg 10010" do
        subject { described_class.new(response).infrastructure? }
        let(:detail_code) { "10001" }

        it { is_expected.to be(true) }
      end

      context "when detail_code starts with 2" do
        subject { described_class.new(response).infrastructure? }
        let(:detail_code) { "20001" }

        it { is_expected.to be(true) }
      end

      context "when detail_code starts with 3" do
        subject { described_class.new(response).infrastructure? }
        let(:detail_code) { "30001" }

        it { is_expected.to be(false) }
      end
    end

    describe "business?" do
      context "when detail_code starts with 1 eg 10010" do
        subject { described_class.new(response).business? }
        let(:detail_code) { "10001" }

        it { is_expected.to be(false) }
      end

      context "when detail_code starts with 3 eg 10010" do
        subject { described_class.new(response).business? }
        let(:detail_code) { "30001" }

        it { is_expected.to be(true) }
      end
    end
  end
end
