# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.find_or_create_by_email('admin@example.com', :password => 'admin')
puts "First user created with email 'admin@example.com' and password 'admin'"

project = Project.find_or_create_by_name('Test project 1')

(1..10).to_a.each do |n|
  project.factors.find_or_create_by_name("Factor #{n}")
  project.stages.find_or_create_by_name("Stage #{n}")
end

Task.find_or_create_by_name("Sample task A", :stage => Stage.find(3), :factor => Factor.find(5));
Task.find_or_create_by_name("Sample task B", :stage => Stage.find(6), :factor => Factor.find(2));
