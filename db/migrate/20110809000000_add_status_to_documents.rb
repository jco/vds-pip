class AddStatusToDocuments < ActiveRecord::Migration
  def self.up
    change_table(:documents) do |t|
      t.string :status
    end
  end

  def self.down
    remove_column :documents, :status
  end
end
