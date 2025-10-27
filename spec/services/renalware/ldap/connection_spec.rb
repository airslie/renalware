module Renalware
  module Ldap
    describe Connection do
      subject(:connection) do
        described_class.new(username: username, password: password)
      end

      let(:username) { "testuser" }
      let(:password) { "password123" }
      let(:ldap_mock) { instance_double(Net::LDAP) }
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
        allow(Renalware.config).to receive_messages(
          ldap_host: "ldap.example.com",
          ldap_port: 389,
          ldap_base: "dc=renalware,dc=app",
          ldap_ssl: false,
          ldap_attribute_mappings: {
            "username" => "uid",
            "email" => "mail",
            "given_name" => "givenName",
            "family_name" => "sn"
          },
          ldap_admin_user: "admin",
          ldap_admin_password: "admin_password",
          ldap_clinical_group: "cn=clinical,ou=groups,dc=renalware,dc=app",
          ldap_readonly_group: "cn=readonly,ou=groups,dc=renalware,dc=app",
          ldap_logger: true
        )
        allow(Net::LDAP).to receive(:new).and_return(ldap_mock)
      end

      describe "#initialize" do
        it "sets username" do
          expect(connection.username).to eq(username)
        end

        it "accepts optional password" do
          conn = described_class.new(username: username)
          expect(conn.username).to eq(username)
        end
      end

      describe "#valid_credentials?" do
        let(:result) { Struct.new(:code).new(0) }

        before do
          allow(ldap_mock).to receive(:search).and_yield(user_entry)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
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

      describe "#param" do
        let(:result) { Struct.new(:code).new(0) }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
        end

        context "when user is found" do
          before do
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
          end

          it "returns the requested attribute" do
            expect(connection.param("mail")).to eq(["testuser@example.com"])
          end

          it "returns the givenName attribute" do
            expect(connection.param("givenName")).to eq(["Test"])
          end
        end

        context "when user is not found" do
          before do
            allow(ldap_mock).to receive(:search)
          end

          it "returns nil" do
            expect(connection.param("mail")).to be_nil
          end
        end

        context "when attribute is empty" do
          before do
            empty_entry = Net::LDAP::Entry.new.tap do |entry|
              entry["dn"] = ["uid=testuser,ou=users,dc=renalware,dc=app"]
              entry["mail"] = []
            end
            allow(ldap_mock).to receive(:search).and_yield(empty_entry)
          end

          it "returns nil" do
            expect(connection.param("mail")).to be_nil
          end
        end
      end

      describe "#in_group?" do
        let(:group_dn) { "cn=clinical,ou=groups,dc=renalware,dc=app" }
        let(:user_dn) { "uid=testuser,ou=users,dc=renalware,dc=app" }
        let(:result) { Struct.new(:code).new(0) }
        let(:filter) { instance_double(Net::LDAP::Filter) }
        let(:admin_ldap) { instance_double(Net::LDAP) }
        let(:admin_connection) { instance_double(described_class) }
        let(:admin_adapter_mock) { instance_double(Adapter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(ldap_mock).to receive(:search).and_yield(user_entry)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
          allow(described_class).to receive(:new).and_call_original
          allow(described_class).to receive(:new)
            .with(username: "admin", password: "admin_password")
            .and_return(admin_connection)
          allow(admin_connection).to receive(:bind).and_return(admin_ldap)
        end

        context "when user is in the group" do
          before do
            group_entry = Net::LDAP::Entry.new.tap do |entry|
              entry["dn"] = [group_dn]
              entry["member"] = [user_dn]
            end
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            allow(admin_ldap).to receive(:search).and_yield(group_entry)
            allow(admin_ldap).to receive(:get_operation_result).and_return(result)
          end

          it "returns true" do
            expect(connection.in_group?(group_dn)).to be(true)
          end
        end

        context "when user is not in the group" do
          before do
            group_entry = Net::LDAP::Entry.new.tap do |entry|
              entry["dn"] = [group_dn]
              entry["member"] = ["uid=otheruser,ou=users,dc=renalware,dc=app"]
            end
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            allow(admin_ldap).to receive(:search).and_yield(group_entry)
            allow(admin_ldap).to receive(:get_operation_result).and_return(result)
          end

          it "returns false" do
            expect(connection.in_group?(group_dn)).to be(false)
          end
        end

        context "when group does not exist" do
          before do
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            allow(admin_ldap).to receive(:search)
            allow(admin_ldap).to receive(:get_operation_result).and_return(result)
          end

          it "returns false" do
            expect(connection.in_group?(group_dn)).to be(false)
          end
        end

        context "when using custom group attribute" do
          before do
            group_entry = Net::LDAP::Entry.new.tap do |entry|
              entry["dn"] = [group_dn]
              entry["uniqueMember"] = [user_dn]
            end
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            allow(admin_ldap).to receive(:search).and_yield(group_entry)
            allow(admin_ldap).to receive(:get_operation_result).and_return(result)
          end

          it "checks the specified attribute" do
            expect(connection.in_group?(group_dn, "uniqueMember")).to be(true)
          end
        end
      end

      describe "#user_dn" do
        let(:result) { Struct.new(:code).new(0) }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
        end

        context "when user is found in LDAP" do
          before do
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
          end

          it "returns the DN from the LDAP entry" do
            expect(connection.user_dn).to eq("uid=testuser,ou=users,dc=renalware,dc=app")
          end

          it "caches the result" do
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            connection.user_dn
            connection.user_dn
            expect(ldap_mock).to have_received(:search).once
          end
        end

        context "when user is not found in LDAP" do
          before do
            allow(ldap_mock).to receive(:search)
          end

          it "constructs DN from config" do
            expected_dn = "uid=testuser,dc=renalware,dc=app"
            expect(connection.user_dn).to eq(expected_dn)
          end
        end
      end

      describe "#search_for_user" do
        let(:result) { Struct.new(:code).new(0) }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
        end

        context "when user exists" do
          before do
            allow(ldap_mock).to receive(:search).with(filter: filter).and_yield(user_entry)
          end

          it "returns the user entry" do
            expect(connection.search_for_user).to eq(user_entry)
          end

          it "caches the result" do
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            connection.search_for_user
            connection.search_for_user
            expect(ldap_mock).to have_received(:search).once
          end
        end

        context "when user does not exist" do
          before do
            allow(ldap_mock).to receive(:search)
          end

          it "returns nil" do
            expect(connection.search_for_user).to be_nil
          end
        end

        context "when multiple users match (takes first)" do
          let(:second_entry) do
            Net::LDAP::Entry.new.tap do |entry|
              entry["dn"] = ["uid=testuser2,ou=users,dc=renalware,dc=app"]
            end
          end

          before do
            allow(ldap_mock).to receive(:search).and_yield(user_entry).and_yield(second_entry)
          end

          it "returns the first matching entry" do
            expect(connection.search_for_user).to eq(user_entry)
          end
        end
      end

      describe "#bind" do
        let(:result) { Struct.new(:code).new(0) }
        let(:user_dn) { "uid=testuser,ou=users,dc=renalware,dc=app" }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        before do
          allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          allow(ldap_mock).to receive(:search).and_yield(user_entry)
          allow(ldap_mock).to receive(:get_operation_result).and_return(result)
        end

        context "when use_user_dn is true" do
          context "when bind succeeds" do
            before do
              allow(ldap_mock).to receive(:auth).with(user_dn, password)
              allow(ldap_mock).to receive(:bind).and_return(true)
            end

            it "authenticates with user DN" do
              allow(ldap_mock).to receive(:auth).with(user_dn, password)
              connection.bind
              expect(ldap_mock).to have_received(:auth).with(user_dn, password)
            end

            it "returns the ldap connection" do
              allow(ldap_mock).to receive(:auth)
              allow(ldap_mock).to receive(:bind).and_return(true)
              expect(connection.bind).to eq(ldap_mock)
            end
          end

          context "when bind fails" do
            before do
              allow(ldap_mock).to receive(:auth).with(user_dn, password)
              allow(ldap_mock).to receive(:bind).and_return(false)
            end

            it "returns nil" do
              expect(connection.bind).to be_nil
            end
          end
        end

        context "when use_user_dn is false" do
          before do
            allow(ldap_mock).to receive(:auth).with(username, password)
            allow(ldap_mock).to receive(:bind).and_return(true)
          end

          it "authenticates with username" do
            allow(ldap_mock).to receive(:auth).with(username, password)
            connection.bind(use_user_dn: false)
            expect(ldap_mock).to have_received(:auth).with(username, password)
          end

          it "returns the ldap connection" do
            expect(connection.bind(use_user_dn: false)).to eq(ldap_mock)
          end
        end
      end

      describe "error handling" do
        let(:result) { Struct.new(:code, :message).new(1, "LDAP connection failed") }
        let(:filter) { instance_double(Net::LDAP::Filter) }

        context "when LDAP operation fails" do
          before do
            allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
            allow(ldap_mock).to receive(:search)
            allow(ldap_mock).to receive(:get_operation_result).and_return(result)
          end

          it "raises Error with meaningful message" do
            expect { connection.search_for_user }
              .to raise_error(Error, /LDAP operation failed/)
          end

          it "logs the error" do
            allow(Rails.logger).to receive(:error)
            expect { connection.search_for_user }.to raise_error(Error)
            expect(Rails.logger).to have_received(:error)
              .with(/LDAP operation failed: 1 - LDAP connection failed/)
          end
        end

        context "when admin bind fails" do
          let(:failed_admin_connection) { instance_double(described_class, bind: nil) }

          before do
            allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
            allow(ldap_mock).to receive(:search).and_yield(user_entry)
            allow(ldap_mock).to receive(:get_operation_result)
              .and_return(Struct.new(:code).new(0))
            allow(described_class).to receive(:new).and_call_original
            allow(described_class).to receive(:new)
              .with(username: "admin", password: "admin_password")
              .and_return(failed_admin_connection)
          end

          it "raises Error" do
            expect { connection.in_group?("cn=test,dc=renalware,dc=app") }
              .to raise_error(Error, /Cannot bind to LDAP server with admin credentials/)
          end
        end
      end

      describe "SSL configuration" do
        let(:filter) { instance_double(Net::LDAP::Filter) }

        context "when SSL is enabled" do
          before do
            allow(Renalware.config).to receive(:ldap_ssl).and_return(true)
            allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          end

          it "creates LDAP connection with simple_tls encryption" do
            allow(Net::LDAP).to receive(:new).with(
              hash_including(encryption: :simple_tls)
            ).and_return(ldap_mock)
            allow(ldap_mock).to receive(:search)
            allow(ldap_mock).to receive(:get_operation_result)
              .and_return(Struct.new(:code).new(0))

            connection.search_for_user
            expect(Net::LDAP).to have_received(:new)
              .with(hash_including(encryption: :simple_tls))
          end
        end

        context "when SSL is disabled" do
          before do
            allow(Renalware.config).to receive(:ldap_ssl).and_return(false)
            allow(Net::LDAP::Filter).to receive(:eq).with("uid", username).and_return(filter)
          end

          it "creates LDAP connection without encryption" do
            allow(Net::LDAP).to receive(:new).with(
              hash_including(encryption: nil)
            ).and_return(ldap_mock)
            allow(ldap_mock).to receive(:search)
            allow(ldap_mock).to receive(:get_operation_result)
              .and_return(Struct.new(:code).new(0))

            connection.search_for_user
            expect(Net::LDAP).to have_received(:new)
              .with(hash_including(encryption: nil))
          end
        end
      end
    end
  end
end
