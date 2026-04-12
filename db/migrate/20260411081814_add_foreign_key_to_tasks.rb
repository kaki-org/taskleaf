# frozen_string_literal: true

class AddForeignKeyToTasks < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :tasks, :users
  end
end
