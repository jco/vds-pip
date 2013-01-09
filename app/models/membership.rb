#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Membership < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  after_create :create_locations

  # New code - for creating locations each of this user's project's documents/folders
  def create_locations
    # First use 0 for coordinates
    x,y = 0,0

    # Make locations for each folder
    project.folders.each { |f|
      # Deal with *stage folders* (folders DIRECTLY under the project - f)
      Location.find_or_create_by_user_id_and_folder_id(self.user.id, f.id, :x=>x, :y=>y)
      # Update coordinates
      x+=10; y+=10
      ## Reset to zero if at screen size
      if x >= 600
        x=0
      end
      if y >= 400
        y=0
      end

      # Deal with documents under stage folders
      f.documents.each { |d| 
          Location.find_or_create_by_user_id_and_document_id(user.id, d.id, :x=>x, :y=>y)
          # Update coordinates
          x+=10; y+=10
          ## Reset to zero if at screen size
          if x >= 600
            x=0
          end
          if y >= 400
            y=0
          end
        }

      # Deal with *factor_folders* (f.folders)
      f.folders.each { |subfolder| 
        # puts '-----------------------------------------'
        # puts "task folder creation for #{subfolder.name}: #{Location.count}, user id: #{self.user.id}, folder id: #{subfolder.id}"
        Location.find_or_create_by_user_id_and_folder_id(self.user.id, subfolder.id, :x=>x, :y=>y)
        # puts "task folder creation of location after: #{Location.count}"
        # puts '-----------------------------------------'

        # Update coordinates
        x+=10; y+=10
        ## Reset to zero if at screen size
        if x >= 600
          x=0
        end
        if y >= 400
          y=0
        end

        # Deal with documents in factor_folders
        subfolder.documents.each { |d| 
          Location.find_or_create_by_user_id_and_document_id(user.id, d.id, :x=>x, :y=>y)
          # Update coordinates
          x+=10; y+=10
          ## Reset to zero if at screen size
          if x >= 600
            x=0
          end
          if y >= 400
            y=0
          end
        }
      }

      # Deal with *task_folders*
      task_folders = f.folders.map { |fo| fo.folders }.flatten # use flatten here to get the full list of task_folders
      task_folders.each { |subfolder| 
        # puts '-----------------------------------------'
        # puts "task folder creation for #{subfolder.name}: #{Location.count}, user id: #{self.user.id}, folder id: #{subfolder.id}"
        Location.find_or_create_by_user_id_and_folder_id(self.user.id, subfolder.id, :x=>x, :y=>y)
        # puts "task folder creation of location after: #{Location.count}"
        # puts '-----------------------------------------'

        # Update coordinates
        x+=10; y+=10
        ## Reset to zero if at screen size
        if x >= 600
          x=0
        end
        if y >= 400
          y=0
        end

        # Deal with documents in task_folders
        subfolder.documents.each { |d| 
          Location.find_or_create_by_user_id_and_document_id(user.id, d.id, :x=>x, :y=>y)
          # Update coordinates
          x+=10; y+=10
          ## Reset to zero if at screen size
          if x >= 600
            x=0
          end
          if y >= 400
            y=0
          end
        }
      }
    }

    ## Deal with documents DIRECTLY under the project
    # First reset the project's x and y variables to 0
    x,y = 0,0
    # Make locations for each document
    project.documents.each { |d| 
      Location.find_or_create_by_user_id_and_document_id(user.id, d.id, :x=>x, :y=>y)
      # puts '-----------------------------------------'
      # puts "one document location found or made"
      # puts '-----------------------------------------'
      # Update coordinates
      x+=10; y+=10
      ## Reset to zero if at screen size
      if x >= 600
        x=0
      end
      if y >= 400
        y=0
      end
    }
  end
end
