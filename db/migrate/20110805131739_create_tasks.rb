#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :parent_task_id
      t.integer :stage_id
      t.integer :factor_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
