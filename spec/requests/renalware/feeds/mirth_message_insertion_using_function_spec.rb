# frozen_string_literal: true

describe "Simulation of Mirth inserting an HL7 message using our helper function" do
  include DatabaseFunctionsSpecHelper

  let(:hl7_with_uom_caret_encoded_as_slash_s_slash) do
    <<~RAW
      MSH| the folowing OBX line is required in this test
      OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
    RAW
  end

  def simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
    hl7_msg = hl7_with_uom_caret_encoded_as_slash_s_slash
    sql = "select renalware.new_hl7_message('#{hl7_msg}');"
    ActiveRecord::Base.connection.execute(sql)
  end

  describe "postgres trigger 'feed_messages_preprocessing_trigger'" do
    let(:expected_obx_preprocessed_by_trigger) { "OBX|1|TX|WBC^WBC^MB||6.09|10\\\\S\\\\12/L|" }

    it "replaces \S\ with \\S\\ when the handler+message are inserted into delayed_jobs" do
      simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
      expect(Delayed::Job.first.handler).to include(expected_obx_preprocessed_by_trigger)
    end

    context "when the trigger is disabled" do
      before { toggle_all_triggers(:off) }

      after { toggle_all_triggers(:on) }

      it "does not replace anything - i.e. we know the trigger was working" do
        simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
        expect(Delayed::Job.first.handler).not_to include(expected_obx_preprocessed_by_trigger)
      end
    end

    it "replaces \S\ with \\S\\ when the handler+message are inserted into delayed_jobs" do
      simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs

      expect(Delayed::Job.first.created_at).not_to be_nil
      expect(Delayed::Job.first.updated_at).not_to be_nil
    end
  end
end
