class CreatePathologySenders < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      comment = <<~COMMENT.squish
        The HL7 MSH segment defines a sending application and sending facility e.g. at MSE Basildon
        'MSH|^~\&|WinPath|RAJ01|RenalWare|MSE|202110261045||ORU^R01|116182217|P|2.3|1||AL'
        has application 'WinPath' and facility 'RAJ01' (in this case fcaility is the hospital code
        but that is not guaranteed), and at Kings e.g.
        'MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||'
        contains application 'HM' and facility 'LBE'.
        Defining in this table the expected HL7 sending facilities (and optional applications)
        allows us to use these definitions when creating OBX mappings - for instance we can delcare
        that the OBX code 'HB' from sending facility 'RAJ32' should map to the observation description
        with code 'HGB'.
      COMMENT
      create_table(:pathology_senders, comment: comment) do |t|
        t.string :sending_facility, null: false, comment: "From MSH segment"
        t.string :sending_application, null: false, default: "*", comment: "From MSH segment"
        t.timestamps null: false
      end
      add_index(
        :pathology_senders,
        [:sending_facility, :sending_application],
        unique: true,
        name: :pathology_senders_idx
      )
    end
  end
end
