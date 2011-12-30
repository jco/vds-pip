#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.string :name
      t.integer :project_id
      t.integer :position # for acts_as_list

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
