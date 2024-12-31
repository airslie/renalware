module DatabaseFunctionsSpecHelper
  def toggle_all_triggers(option)
    arg = option == :off ? "replica" : "DEFAULT"
    ActiveRecord::Base.connection.execute("SET session_replication_role = #{arg};")
  end
end
