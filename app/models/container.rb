module Container
# specifically, a container for documents and folders

  # returns a list of every dependency that touches something in this container
  # this method would be faster in SQL
  def contained_dependencies
    Dependency.all.select do |dep|
      documents.include?(dep.upstream_item) || documents.include?(dep.downstream_item) ||
      folders.include?(dep.upstream_item) || folders.include?(dep.downstream_item)
    end
  end

end
