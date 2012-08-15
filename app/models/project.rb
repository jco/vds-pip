#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Project < ActiveRecord::Base
  include Container
  self.include_root_in_json = false
  # remove commented...
  # has_many :stages, :order => :position
  # has_many :factors
  # has_many :memberships
  has_many :tasks
  
  # These are only the top-level docs and folders.
  has_many :documents
  has_many :folders
  
  has_many :memberships
  has_many :users, :through => :memberships
  after_create :create_memberships_for_site_admins
  after_create :create_proper_tasks

  # Documents and folders within this project
  def items
    items = [ ]
    self.documents.each do |doc|
      items << doc
    end
    self.folders.each do |folder|
      items << folder
    end
    return items
  end

  def tasks
    stages.map { |stage| stage.tasks }.flatten
  end

  def serializable_hash(options = nil)
    {
      :id => id,
      :name => name,
      :folders => folders,
      :documents => documents
    }
  end

  def to_s
    self.name
  end
  
  private
    def create_proper_tasks
      # Do something to create the tasks you want
      # Ex:
      task1 = Task.find_or_create_by_name("Task 1", :stage_id => Stage.find_by_name("Assess").id, 
              :factor_id => Factor.find_by_name("Site and climate").id,
              :project_id => self.id)
      task2 = Task.find_or_create_by_name("Task 2", :stage_id => Stage.find_by_name("Assess").id, 
              :factor_id => Factor.find_by_name("Site and climate").id,
              :parent_task_id => task1.id)
      task3 = Task.find_or_create_by_name("Task 3", :stage_id => Stage.find_by_name("Assess").id, 
              :factor_id => Factor.find_by_name("Site and climate").id,
              :project_id => self.id)
    end
  
    def create_memberships_for_site_admins
      User.where(:role=>'site_admin').each do |u|
        Membership.find_or_create_by_user_id_and_project_id(u.id, self.id)
      end
    end
end
