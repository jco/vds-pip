# require 'composite_primary_keys'
class Location < ActiveRecord::Base
  # set_primary_keys :user_id, :folder_id, :document_id
  belongs_to :user
  belongs_to :folder
  belongs_to :document
  
  validate :folder_xor_document
  
  # must have a folder id or a document id but not both
  def folder_xor_document
    unless folder_id.blank? ^ document_id.blank?
      errors[:base] << "Location can only be for a folder or a document - not both."
    end
  end

  def self.clear_bad_locs
    arr = [ ]
    Location.all.each { |location|
      tmp = [ ] 
      if location.document_id.nil?
        tmp = [ location.id, location.user_id, location.folder_id, 'f' ]
      else
        tmp = [ location.id, location.user_id, location.document_id, 'd' ]
      end
      arr << tmp
    }
    puts "arr: #{arr.inspect}"
    # post: arr is an array of arrays, like [ [1,2,3,'f'], [4,5,6,'d'] ], 
    # where each element is of the format [location id, user id, item id, document or folder]
    
    # Now compare each element in arr with each other
    0.upto(arr.size-2) { |i|
      this = arr[i]
      (i+1).upto(arr.size-1) { |j|
        that = arr[j]
        if this[1..3] == that[1..3]
          puts "Deleting location (#{that[0]})"
          Location.destroy(that[0])
        end
      }
    }
  end
end
