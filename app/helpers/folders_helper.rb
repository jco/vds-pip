module FoldersHelper
  def breadcrumbs_for(folder)
    items = folder_hierarchy_array(folder)
    items.map {|i| link_to(i.name, i) }.join(h(' --> ')).html_safe
  end

  def folder_hierarchy_array(folder)
    hierarchy = folder_hierarchy_array_helper([folder])
    project = hierarchy.first.project
    [project] + hierarchy
  end

  def folder_hierarchy_array_helper(folders)
    if folders.first.parent_folder
      folder_hierarchy_array_helper([folders.first.parent_folder] + folders)
    else
      folders
    end
  end
    
end
