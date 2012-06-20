class RemoveXFromDocuments < ActiveRecord::Migration
  def self.up
    remove_column :documents, :x
  end

  def self.down
    add_column :documents, :x, :integer, :default => 0, :null => false
  end
end
