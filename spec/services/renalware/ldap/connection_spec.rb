module Renalware
  module Ldap
    describe Connection do
      subject(:connection) do
        described_class.new(username:, password:)
      end

      let(:username) { "testuser" }
      let(:password) { "password123" }
      let(:ldap_mock) { instance_double(Net::LDAP).as_null_object }
      let(:admin_ldap_mock) { instance_double(Net::LDAP).as_null_object }
      let(:user_entry) do
        Net::LDAP::Entry.new.tap do |entry|
          entry["dn"] = ["uid=testuser,ou=users,dc=renalware,dc=app"]
          entry["mail"] = ["testuser@example.com"]
          entry["givenName"] = ["Test"]
          entry["sn"] = ["User"]
          entry["cn"] = ["Test User"]
        end
      end

      before do
        allow(Net::LDAP).to receive(:new).and_return(
          ldap_mock, admin_ldap_mock, admin_ldap_mock, admin_ldap_mock
        )
        allow(ldap_mock).to receive(:auth)
        allow(ldap_mock).to receive_messages(
          bind: true,
          get_operation_result: Struct.new(:code).new(0)
        )
        allow(admin_ldap_mock).to receive(:auth)
        allow(admin_ldap_mock).to receive_messages(
          bind: true,
          get_operation_result: Struct.new(:code).new(0)
        )
      end

      describe "#initialize" do
        it "sets username" do
          expect(connection.username).to eq(username)
        end

        it "accepts optional password" do
          conn = described_class.new(username:)
          expect(conn.username).to eq(username)
        end
      end

      describe "#valid_credentials?" do
        let(:result) { Struct.new(:code).new(0) }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(admin_ldap_mock).to receive(:search).and_yield(user_entry)
          allow(admin_ldap_mock).to receive(:get_operation_result).and_return(result)
        end

        context "when password is blank" do
          let(:password) { "" }

          it "returns false without attempting bind" do
            allow(ldap_mock).to receive(:bind)
            expect(connection.valid_credentials?).to be(false)
            expect(ldap_mock).not_to have_received(:bind)
          end
        end

        context "when password is nil" do
          let(:password) { nil }

          it "returns false without attempting bind" do
            allow(ldap_mock).to receive(:bind)
            expect(connection.valid_credentials?).to be(false)
            expect(ldap_mock).not_to have_received(:bind)
          end
        end

        context "when password is present" do
          context "when bind succeeds" do
            before do
              allow(ldap_mock).to receive(:auth)
              allow(ldap_mock).to receive(:bind).and_return(true)
            end

            it "returns true" do
              expect(connection.valid_credentials?).to be(true)
            end
          end

          context "when bind fails" do
            before do
              allow(ldap_mock).to receive(:auth)
              allow(ldap_mock).to receive(:bind).and_return(false)
            end

            it "returns false" do
              expect(connection.valid_credentials?).to be(false)
            end
          end
        end
      end

      describe "error handling" do
        let(:result) { Struct.new(:code, :message).new(1, "LDAP connection failed") }

        context "when LDAP operation fails" do
          before do
            allow(ldap_mock).to receive(:search)
            allow(ldap_mock).to receive(:get_operation_result).and_return(result)
            allow(admin_ldap_mock).to receive(:search)
            allow(admin_ldap_mock).to receive(:get_operation_result).and_return(result)
          end

          it "raises Error with meaningful message" do
            expect { connection.valid_credentials? }
              .to raise_error(Error, /operation failed/)
          end

          it "logs the error" do
            allow(Rails.logger).to receive(:error)
            expect { connection.valid_credentials? }.to raise_error(Error)
            expect(Rails.logger).to have_received(:error)
              .with(/operation failed: 1 - LDAP connection failed/)
          end
        end

        context "when admin bind fails" do
          before do
            allow(ldap_mock).to receive(:bind).and_return(false)
            allow(admin_ldap_mock).to receive(:bind).and_return(false)
          end

          it "raises Error" do
            expect { connection.valid_credentials? }
              .to raise_error(Error, /Cannot bind to LDAP server with admin credentials/)
          end
        end
      end

      describe "SSL configuration" do
        context "when SSL is enabled" do
          it "creates LDAP connection with simple_tls encryption" do
            allow(Net::LDAP).to receive(:new).with(
              hash_including(encryption: :simple_tls)
            ).and_return(ldap_mock, admin_ldap_mock)
            allow(admin_ldap_mock).to receive(:search).with(any_args).and_yield(user_entry)
            allow(admin_ldap_mock).to receive(:get_operation_result)
              .and_return(Struct.new(:code).new(0))

            connection.valid_credentials?
            expect(Net::LDAP).to have_received(:new)
              .with(hash_including(encryption: :simple_tls)).at_least(:once)
          end
        end
      end
    end
  end
end
