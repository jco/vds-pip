#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# require 'composite_primary_keys'

# A big thing where you might run into issues here is validations set in the models/.
# If something isn't getting created, it's possible that a model validation isn't passing.

# Site admins
admin1 = User.find_or_create_by_email('admin1@example.com', :password => 'admin') do |u|
  u.role = 'site_admin'
end
admin2 = User.find_or_create_by_email('admin2@example.com', :password => 'admin') do |u|
  u.role = 'site_admin'
end
admin3 = User.find_or_create_by_email('admin3@example.com', :password => 'admin') do |u|
  u.role = 'site_admin'
end

# Project managers
pm1 = User.find_or_create_by_email('pm1@example.com', :password => 'admin') do |u|
  u.role = 'project_manager'
end
pm2 = User.find_or_create_by_email('pm2@example.com', :password => 'admin') do |u|
  u.role = 'project_manager'
end
pm3 = User.find_or_create_by_email('pm3@example.com', :password => 'admin') do |u|
  u.role = 'project_manager'
end

# Normal users
user1 = User.find_or_create_by_email('user1@example.com', :password => 'admin') do |u|
  u.role = 'normal_user'
end
user2 = User.find_or_create_by_email('user2@example.com', :password => 'admin') do |u|
  u.role = 'normal_user'
end
user3 = User.find_or_create_by_email('user3@example.com', :password => 'admin') do |u|
  u.role = 'normal_user'
end

# Projects
project1 = Project.find_or_create_by_name('Test project 1')
project2 = Project.find_or_create_by_name('Test project 2')
project3 = Project.find_or_create_by_name('Test project 3')
project4 = Project.find_or_create_by_name('Test project 4')
project5 = Project.find_or_create_by_name('Test project 5')

# Memberships - note that site admins can control all projects & so don't need any THIS IS THE PROBLEM FOR LOCATIONS

# non-site admins:
Membership.find_or_create_by_user_id_and_project_id(pm1.id, project1.id)
Membership.find_or_create_by_user_id_and_project_id(pm1.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(pm2.id, project3.id)
Membership.find_or_create_by_user_id_and_project_id(pm2.id, project5.id)
Membership.find_or_create_by_user_id_and_project_id(pm3.id, project3.id)
Membership.find_or_create_by_user_id_and_project_id(pm3.id, project4.id)

Membership.find_or_create_by_user_id_and_project_id(user1.id, project1.id)
Membership.find_or_create_by_user_id_and_project_id(user2.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(user3.id, project3.id)

## See config/application.rb for full listing of stages, factors, and tasks.

# Stages
stages = VdsPip::Application::STAGES

# Factors
factors = VdsPip::Application::FACTORS

# Tasks - not used
# tasks = = VdsPip::Application::TASKS 

# Link stages and projects
# stages.each { |s| Stage.create!(:name => s) }#find_or_create_by_name(s) }
stages.each { |s| Stage.find_or_create_by_name(s) }

# Link factors and projects
# factors.each { |f| Factor.create!(:name => f) }# find_or_create_by_name(f) }
factors.each { |f| Factor.find_or_create_by_name(f) }

# Tasks
# examples - this works
# task1 = Task.find_or_create_by_name("Sample task A", :stage_id => Stage.find_by_name(stages[0]).id, 
#         :factor_id => Factor.find_by_name(factors[0]).id,
#         :project_id => project1.id)
# task2 = Task.find_or_create_by_name("Sample task B", :stage_id => Stage.find_by_name(stages[0]).id, 
#         :factor_id => Factor.find_by_name(factors[0]).id,
#         :parent_task_id => task1.id)


# Folders
# if Folder.count == 0
#   Folder.create!(:name=>"folder 1",:project_id=>Project.all[0].id, :task_id => task1.id)
#   Folder.create!(:name=>"folder 2",:parent_folder_id=>Folder.find_by_name('folder 1').id)
#   Folder.create!(:name=>"folder 3",:project_id=>Project.all[0].id)
#   puts '---created folders'
# else
#   puts '---folders not created'
# end

# Documents - bleh, need to specify version
# if Document.count == 0
#   Document.create!(:name=>'document 1',:project_id=>Project.all[0].id)
#   Document.create!(:name=>'document 2',:project_id=>Project.all[0].id)
#   puts '---created documents'
# else
#   puts '---documents not created'
# end