class AddActorRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :actor_role, :string
  end

  def self.down
    remove_column :users, :actor_role
  end
end
