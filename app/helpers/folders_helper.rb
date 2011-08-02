module FoldersHelper
  def breadcrumbs_for(folder)
    folders = badly_named_recursive_function(folder)
    folders.map {|f| link_to(f.name, f) }.join(h(' --> ')).html_safe
  end

  def badly_named_recursive_function(folder)
    badly_named_recursive_function_helper([folder])
  end

  def badly_named_recursive_function_helper(folders)
    if folders.first.parent_folder
      badly_named_recursive_function_helper([folders.first.parent_folder] + folders)
    else
      folders
    end
  end
    
end
