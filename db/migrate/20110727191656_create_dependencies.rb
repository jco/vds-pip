class CreateDependencies < ActiveRecord::Migration
  def self.up
    create_table :dependencies do |t|
      t.references :upstream_document
      t.references :downstream_document

      t.timestamps
    end
  end

  def self.down
    drop_table :dependencies
  end
end
