# Something that can have dependencies with other things.
#
# Required methods: downstream_dependencies and upstream_dependencies.
module Linkable
  def downstream_items
    downstream_dependencies.map{ |dep| dep.downstream_item }
  end

  def upstream_items
    upstream_dependencies.map{ |dep| dep.upstream_item }
  end
end
