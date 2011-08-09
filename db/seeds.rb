# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

project = Project.find_or_create_by_name('Test project 1')

(1..10).to_a.each do |n|
  project.factors.create(:name => "Factor #{n}")
  project.stages.create(:name => "Stage #{n}", :position => n)
end

Task.create(:stage => Stage.find(3), :factor => Factor.find(5), :name => "Task blah");
Task.create(:stage => Stage.find(6), :factor => Factor.find(2), :name => "Task other blah");
