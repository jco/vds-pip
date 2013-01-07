#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

module Container
# specifically, a container for documents and folders
# requires two methods: folders and documents, both return arrays of the
# documents and folders in this container.

  # returns a list of every dependency that touches something in this container
  # this method would be faster in SQL
  def contained_dependencies
    Dependency.all.select do |dep|
      documents.include?(dep.upstream_item) || documents.include?(dep.downstream_item) ||
      folders.include?(dep.upstream_item) || folders.include?(dep.downstream_item)
    end
  end

  # A way to decide the x and y coordinates of a container.
  # Used only in folder.rb create_location_objects
  # This is a rudimentary implementation that randomly chooses a value between 0 and 100.
  def grab_x_location
    rand 100
  end

  def grab_y_location
    rand 100
  end
end
