#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#


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

puts "---created users"

# Projects
project1 = Project.find_or_create_by_name('Test project 1')
project2 = Project.find_or_create_by_name('Test project 2')
project3 = Project.find_or_create_by_name('Test project 3')
project4 = Project.find_or_create_by_name('Test project 4')
project5 = Project.find_or_create_by_name('Test project 5')

# Memberships - note that site admins can control all projects & so don't need any
Membership.find_or_create_by_user_id_and_project_id(pm1.id, project1.id)
Membership.find_or_create_by_user_id_and_project_id(pm1.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(pm2.id, project3.id)
Membership.find_or_create_by_user_id_and_project_id(pm2.id, project5.id)
Membership.find_or_create_by_user_id_and_project_id(pm3.id, project3.id)
Membership.find_or_create_by_user_id_and_project_id(pm3.id, project4.id)

Membership.find_or_create_by_user_id_and_project_id(user1.id, project1.id)
Membership.find_or_create_by_user_id_and_project_id(user2.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(user3.id, project3.id)

# Stages
stages = [
  "Project assessment",
  "Set targets",
  "Meet targets",
  "Confirm targets",
  "Implement targets",
  "Feedback"
]

# Factors
factors = [
  "Site and climate response",
  "Form and massing",
  "External enclosure including roof",
  "Internal configurations",
  "Environmental systems",
  "Energy and water",
  "Material use"
]

# Link stages and projects
stages.each { |s| Stage.find_or_create_by_name(s, :project => project1) }

# Link factors and projects
factors.each { |f| Factor.find_or_create_by_name(f, :project => project1) }

# Tasks
Task.find_or_create_by_name("Sample task A", :stage => Stage.find_by_name(stages[0]), :factor => Factor.find_by_name(factors[0]))
