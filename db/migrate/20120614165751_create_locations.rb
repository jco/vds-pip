class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :user_id
      t.integer :folder_id
      t.integer :document_id
      t.integer :x, :default => 0
      t.integer :y, :default => 0
    end
  end

  def self.down
    drop_table :locations
  end
end
