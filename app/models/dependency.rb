#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Dependency < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :upstream_item, :polymorphic => true
  belongs_to :downstream_item, :polymorphic => true

  validates_presence_of :upstream_item
  validates_presence_of :downstream_item

  def serializable_hash(options = nil)
    [ActionController::RecordIdentifier.dom_id(upstream_item), ActionController::RecordIdentifier.dom_id(downstream_item)]
  end

  # Nicer syntax: Dependency.from(a, :to => b)
  def self.from(up, options)
    Dependency.new(:upstream_item => up, :downstream_item => options[:to])
  end

  def self.is_legal?(options)
    upstream_item = options[:from]
    downstream_item = options[:to]

    # Illegal cases: a list of functions that return true if the given d and u
    # fall under that case.
    illegal_cases = []

    # d is already upstream of u
    illegal_cases 

    illegal_cases.any? {|f| f(upstream_item, downstream_item) }

    !(upstream_item.upstream_items.include?(downstream_item) || upstream_item == downstream_item)
  end
end
