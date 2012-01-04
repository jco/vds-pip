#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#


# Users
admin = User.find_or_create_by_email('admin@example.com', :password => 'admin') do |u|
  u.role = 'site_admin'
end
user1 = User.find_or_create_by_email('user1@example.com', :password => 'admin') do |u|
  u.role = 'project_manager'
end
user2 = User.find_or_create_by_email('user2@example.com', :password => 'admin') do |u|
  u.role = 'normal_user'
end

puts "---created users"

# Projects
project = Project.find_or_create_by_name('Test project 1')
project2 = Project.find_or_create_by_name('Test project 2')
project3 = Project.find_or_create_by_name('Test project 3')
project4 = Project.find_or_create_by_name('Test project 4')
project5 = Project.find_or_create_by_name('Test project 5')

# Memberships
Membership.find_or_create_by_user_id_and_project_id(admin.id, project.id)
Membership.find_or_create_by_user_id_and_project_id(admin.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(user1.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(user1.id, project3.id)
Membership.find_or_create_by_user_id_and_project_id(user1.id, project5.id)
Membership.find_or_create_by_user_id_and_project_id(user2.id, project2.id)
Membership.find_or_create_by_user_id_and_project_id(user2.id, project4.id)

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
stages.each { |s| Stage.find_or_create_by_name(s, :project => project) }

# Link factors and projects
factors.each { |f| Factor.find_or_create_by_name(f, :project => project) }

# Tasks
Task.find_or_create_by_name("Sample task A", :stage => Stage.find_by_name(stages[0]), :factor => Factor.find_by_name(factors[0]))
