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

end
