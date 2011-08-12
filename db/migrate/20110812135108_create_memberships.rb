class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :project_manager, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
