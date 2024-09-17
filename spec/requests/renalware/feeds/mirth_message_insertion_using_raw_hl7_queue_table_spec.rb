# frozen_string_literal: true

describe "Simulation of Mirth inserting an HL7 message through a function and into the" \
         "raw HL7 messages table (supersedes new_hl7_message function)" do
  let(:hl7_with_uom_caret_encoded_as_slash_s_slash) do
    <<~RAW
      MSH| the folowing OBX line is required in this test
      OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
    RAW
  end

  def simulate_mirth_inserting_an_hl7_message
    hl7_msg = hl7_with_uom_caret_encoded_as_slash_s_slash
    sql = "select renalware.insert_raw_hl7_message('#{hl7_msg}');"
    ActiveRecord::Base.connection.execute(sql)
  end

  it "replaces \S\ with \\S\\ when the handler+message are inserted into delayed_jobs" do
    simulate_mirth_inserting_an_hl7_message
    raw_message = Renalware::Feeds::RawHL7Message.first
    expect(raw_message).not_to be_nil
    expect(raw_message.body).to eq hl7_with_uom_caret_encoded_as_slash_s_slash
  end
end
