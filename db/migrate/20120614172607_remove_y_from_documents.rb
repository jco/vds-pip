class RemoveYFromDocuments < ActiveRecord::Migration
  def self.up
    remove_column :documents, :y
  end

  def self.down
    add_column :documents, :y, :integer, :default => 0, :null => false
  end
end
