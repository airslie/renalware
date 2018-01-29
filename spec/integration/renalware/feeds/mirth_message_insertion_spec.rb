require "rails_helper"

# Note the handling of \S\ and \\S\\ in this file is a bit confusing.
# Where you see \\S\\ think \S\ and \\\\S\\\\ think \\S\\/
# We can use quoted heredocs to avoid Ruby escaping these strings - I tried this but
# comparing database content doesn't work as that is already escaped when loaded by AR.
# So we're stuck with the mental gymnastics.
RSpec.describe "Simulation of Mirth inserting an HL7 message into delayed_jobs" do
  include DatabaseFunctionsSpecHelper

  let(:hl7_with_uom_caret_encoded_as_slash_s_slash) do
    <<-RAW.strip_heredoc
     MSH| on the the folowing OBX line is required in the this test
     OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Kenneth AMENYAH|
   RAW
  end

  def simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
    hl7_msg = hl7_with_uom_caret_encoded_as_slash_s_slash
    sql = <<-SQL
    insert into renalware.delayed_jobs (handler, run_at)
    values('--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE('#{hl7_msg}',E'\r',E'\n  '), NOW());
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  describe "postgres trigger 'update_current_observation_set_trigger'" do
    let(:expected_obx_preprocessed_by_trigger) { "OBX|1|TX|WBC^WBC^MB||6.09|10\\\\S\\\\12/L|" }

    it "replaces \S\ with \\S\\ when the handler+message are inserted into delayed_jobs" do
      simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
      expect(Delayed::Job.first.handler).to include(expected_obx_preprocessed_by_trigger)
    end

    context "when the trigger is disabled" do
      before { toggle_all_triggers(:off) }
      after { toggle_all_triggers(:on) }

      it "does not replace anything - i.e. the trigger works" do
        simulate_mirth_inserting_a_new_hl7_message_into_delayed_jobs
        expect(Delayed::Job.first.handler).not_to include(expected_obx_preprocessed_by_trigger)
      end
    end
  end
end
