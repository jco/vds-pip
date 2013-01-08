#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Membership < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  after_create :create_locations

  def create_locations
    # New code - for creating locations each of this user's project's documents/folders
    puts '-----------------------------------------'
    puts "creating locations for user, project: #{user.email}, #{user.id}, #{project.name}"
    puts '-----------------------------------------'
    # First use 0
    x,y = 0,0
    # puts '-----------------------------------------'
    # puts "folders:"
    # puts '-----------------------------------------'
    # Make locations for each folder
    project.folders.each { |f|
      l=Location.find_or_create_by_user_id_and_folder_id(self.user.id, f.id, :x=>x, :y=>y)
      puts '-----------------------------------------'
      puts "one folder location found or made: count: #{Location.count} | #{l}"
      puts '-----------------------------------------'
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

    # First reset the project's x and y variables to 0
    x,y = 0,0
    # puts '-----------------------------------------'
    # puts "documents:"
    # puts '-----------------------------------------'
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
