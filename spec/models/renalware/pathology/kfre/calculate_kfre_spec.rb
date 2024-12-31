# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
module Renalware
  module Pathology
    module KFRE
      describe CalculateKFRE do
        subject(:svc) do
          described_class.new(
            sex: sex,
            age: age,
            acr: acr,
            egfr: egfr
          )
        end

        let(:sex) { "F" }
        let(:age) { 21 }
        let(:acr) { "300" }
        let(:egfr) { "10" }

        context "when sex is nil" do
          let(:sex) { nil }

          it "returns silently" do
            expect(svc.call).to be_nil
          end
        end

        context "when age is nil" do
          let(:age) { nil }

          it "returns silently" do
            expect(svc.call).to be_nil
          end
        end

        context "when acr_value is nil or 0" do
          [0, nil].each do |val|
            let(:acr) { val }

            it "returns silently" do
              expect(svc.call).to be_nil
            end
          end
        end

        context "when egfr is nil or 0" do
          [0, nil].each do |val|
            let(:egfr) { val }

            it "returns silently" do
              expect(svc.call).to be_nil
            end
          end
        end

        #  Sex    Age   ACR     EGFR    KFRE2   KFRE5
        [
          ["F",   85,   40.1,   "10.2", 17.5,   49.9 ],
          ["M",   80,   40.1,   21.2,   7.8,    25.2 ],
          ["F",   80,   40.1,   21.2,   6.1,    20.3 ],
          ["F",   73,   40.1,   21.2,   7.1,    23.2 ],
          ["M",   73,   40,     40,     1.2,    4.1  ],
          ["F",   73,   "50.0", "21",   8.0,    25.8 ],
          ["M",   50,   30,     40,     1.7,    5.9  ],
          ["F",   50,   30.9,   30.9,   3.6,    12.4 ],
          ["F",   80,   140.2,  20.1,   11.8,   36.3 ]
        ].each do |sex, age, acr, egfr, yr2, yr5|
          describe "#{sex} age #{age} ACR #{acr} EGFR #{egfr}" do
            subject { svc.call }

            let(:sex) { sex }
            let(:age) { age }
            let(:acr) { acr }
            let(:egfr) { egfr }

            it { is_expected.to have_attributes(yr2: yr2, yr5: yr5) }
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
