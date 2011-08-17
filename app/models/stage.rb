class Stage < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :project
  acts_as_list :scope => :project
  has_many :tasks

  def serializable_hash(options = nil)
    {
      :id => id,
      :name => name,
      :factors => project.factors.map do |factor|
        {
          :id => factor.id,
          :name => factor.name,
          # only fetches top-level tasks, since subtasks don't store stages and factors:
          :tasks => Task.where(:stage_id => self.id, :factor_id => factor.id)
        }
      end
    }
  end

  def to_s
    [position, name].join(". ")
  end

end
