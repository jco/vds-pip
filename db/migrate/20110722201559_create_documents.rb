#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.references :folder
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
