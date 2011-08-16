class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :project_id
      t.integer :user_id
      t.boolean :project_manager

      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
