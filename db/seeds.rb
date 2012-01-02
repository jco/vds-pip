#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# if User.where(:role => 'site_admin').count == 0
#   User.create(:password=>"password",:password_confirmation=>"password",
#               :email=>"admin@example.com",:role=>"site_admin")
#   puts "Created site admins"
# else
#   puts "Site admins already exist"
# end

# not working...? model validation? what else did I change?
admin = User.find_or_create_by_email('admin@example.com', :password => 'admin', :password_confirmation => 'admin',
  :role => 'site_admin')
puts "First user created with email 'admin@example.com', password 'admin', and role 'site_admin'"

project = Project.find_or_create_by_name('Test project 1')
Membership.find_or_create_by_user_id_and_project_id(admin.id, project.id)

stages = [
  "Project assessment",
  "Set targets",
  "Meet targets",
  "Confirm targets",
  "Implement targets",
  "Feedback"
]

factors = [
  "Site and climate response",
  "Form and massing",
  "External enclosure including roof",
  "Internal configurations",
  "Environmental systems",
  "Energy and water",
  "Material use"
]

stages.each { |s| Stage.find_or_create_by_name(s, :project => project) }
factors.each { |f| Factor.find_or_create_by_name(f, :project => project) }

Task.find_or_create_by_name("Sample task A", :stage => Stage.find_by_name(stages[0]), :factor => Factor.find_by_name(factors[0]))
