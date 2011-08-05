class LinkDocumentsAndTasks < ActiveRecord::Migration
  def self.up
    add_column(:documents, :task_id, :integer)
  end

  def self.down
    remove_column(:documents, :task_id)
  end
end
