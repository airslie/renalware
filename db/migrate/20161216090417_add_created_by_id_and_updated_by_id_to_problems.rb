class AddCreatedByIdAndUpdatedByIdToProblems < ActiveRecord::Migration[4.2]
  def up
    add_reference :problem_problems, :created_by, references: :users, index: true, null: true
    add_foreign_key :problem_problems, :users, column: :created_by_id

    add_reference :problem_problems, :updated_by, references: :users, index: true, null: true
    add_foreign_key :problem_problems, :users, column: :updated_by_id

    update_problem_user_column_with_a_system_user_so_we_can_set_null_false(:created_by_id)
    change_column_null :problem_problems, :created_by_id, false
  end

  def down
    remove_foreign_key :problem_problems, column: :created_by_id
    remove_reference :problem_problems, :created_by

    remove_foreign_key :problem_problems, column: :updated_by_id
    remove_reference :problem_problems, :updated_by
  end

  private

  class Problem < ActiveRecord::Base
    self.table_name = :problem_problems
  end

  class User < ActiveRecord::Base
    def self.system_user
      User.find_by!(username: "systemuser")
    end
  end

  def update_problem_user_column_with_a_system_user_so_we_can_set_null_false(column_name)
    if Problem.count > 0
      system_user_id = User.system_user.id
      Problem.all.each do |problem|
        next if problem.send(column_name).present?

        problem.update_attributes(column_name => system_user_id)
      end
    end
  end
end
