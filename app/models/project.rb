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
  # after_create :create_proper_tasks
  after_create :create_stage_factor_task_folders

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
    def create_stage_factor_task_folders
      # Task folder creation prep - see the flow chart (4x3 diagram as of 1/7/13)
      # Basically, the hash "0,0" maps to 3 since there are 3 tasks in the Stage: 'Assess' & Factor: 'Site & Climate' intersection.
      # "0,1" -> 2 (col 0, row 1 has 2 tasks based on the diagram)
      # We only need the size to determine the TASK_NAMES to choose from since we sequentially go through and increment a counter.
      # So, if you look at the flowchart you had, you went down the column "Assess", and counted 3 in the first box, 2 in the next, etc.
      # Fill in rest once we know the values.
      myhash = {
        # Stage: Assess
        "0,0"=>3, "0,1"=>2, "0,2"=>2, "0,3"=>1, #"0,4"=>? once we know what it is
        # Stage: Define
        "1,0"=>2, "1,1"=>3, "1,2"=>2, "1,3"=>1, #"1,4"=>? once we know what it is
        # Stage: Design
        "2,0"=>2, "2,1"=>2, "2,2"=>2, "2,3"=>2
      }
      stage_count = 0 # to iterate over stages
      factor_count = 0 # ''' factors
      task_count = 0 
      VdsPip::Application::STAGES.each do |stage_name| 
        # Stage folders
        f = Folder.create!(:name => stage_name, :project_id => self.id)
        VdsPip::Application::FACTORS.each do |factor_name| 
          # Factor folders
          f2 = Folder.create!(:name => factor_name, :parent_folder_id => f.id)
          # Task folders
          puts '-----------------------------------------'
          puts "stage count: #{stage_count}"
          puts "factor count: #{factor_count}"
          puts "value: " + myhash["#{stage_count},#{factor_count}"].to_s
          puts '-----------------------------------------'
          if myhash["#{stage_count},#{factor_count}"] # we don't know all the tasks yet, so sometimes you get myhash["4,6"]=nil since we don't know how many tasks there are
            myhash["#{stage_count},#{factor_count}"].times {
              puts "task folder name: #{VdsPip::Application::TASKS[task_count]}"
              Folder.create!(:name=>VdsPip::Application::TASKS[task_count], :parent_folder_id => f2.id)
              task_count+=1
            }
          end
          factor_count+=1
        end
        factor_count = 0 # reset factor count with each new stage
        stage_count+=1
      end
    end
  
    def create_memberships_for_site_admins
      User.where(:role=>'site_admin').each do |u|
        Membership.find_or_create_by_user_id_and_project_id(u.id, self.id)
      end
    end
end
