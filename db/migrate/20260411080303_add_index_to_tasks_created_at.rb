class AddIndexToTasksCreatedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :tasks, :created_at
  end
end
