class MakeDependenciesPolymorphic < ActiveRecord::Migration
  def self.up
    change_table(:dependencies) do |t|
      t.remove :upstream_document_id
      t.remove :downstream_document_id

      t.integer :upstream_item_id
      t.string :upstream_item_type

      t.integer :downstream_item_id
      t.string :downstream_item_type
    end
  end

  def self.down
    change_table(:dependencies) do |t|
      t.remove :downstream_item_type
      t.remove :downstream_item_id

      t.remove :upstream_item_type
      t.remove :upstream_item_id

      t.integer :downstream_document_id
      t.integer :upstream_document_id
  end
end
