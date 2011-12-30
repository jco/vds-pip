#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

module ApplicationHelper
  def breadcrumbs_for(hierarchical_thing)
    items = hierarchical_array_for(hierarchical_thing)
    items.map do |item|
      begin
        link_to(item.name, item)
      rescue NoMethodError
        item.name
      end
    end.join(h(' --> ')).html_safe
  end

private

  def hierarchical_array_for(thing)
    hierarchy_array_helper([thing])
  end

  def hierarchy_array_helper(things)
    if has_parent(things)
      hierarchy_array_helper([get_parent(things)] + things)
    else
      things
    end
  end

  def has_parent(things)
    !get_parent(things).nil?
  end

  def get_parent(things)
    first_thing = things.first
    if first_thing.is_a?(Folder)
      first_thing.parent
    elsif first_thing.is_a?(Project)
      nil
    else
      raise "Tried to get the parent of something unexpected: #{first_thing.inspect}"
    end
  end

end
