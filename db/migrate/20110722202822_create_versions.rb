class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.references :document
      t.string :external_url
      t.string :file

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
