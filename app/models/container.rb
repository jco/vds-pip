#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

module Container
# specifically, a container for documents and folders
# requires two methods: folders and documents, both return arrays of the
# documents and folders in this container.

  # returns a list of every dependency that has both endpoints in this container
  # this method would be faster in SQL
  def contained_dependencies
    Dependency.all.select do |dep|
      contents.include?(dep.upstream_item) && contents.include?(dep.downstream_item)
    end
  end

  def contents
    documents + folders
  end

end
