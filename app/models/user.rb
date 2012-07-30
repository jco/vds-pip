#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class User < ActiveRecord::Base
  # Sets up multiple threads so we can access User.current (which is current_user) in models
  # http://stackoverflow.com/questions/2513383/access-current-user-in-model, http://rails-bestpractices.com/posts/47-fetch-current-user-in-models
  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
  
  
  attr_accessible :email, :password, :password_confirmation, :role, :project_tokens
  attr_reader :project_tokens # http://railscasts.com/episodes/258-token-fields
  
  attr_accessible :project_ids # needed for check box forms in users _form, when a normal user creates another user
  attr_accessor :password
  before_save :encrypt_password
  
  # These are user roles, mainly for control - not as important as actor roles
  ROLES = %w[site_admin project_manager normal_user]
  MINOR_ROLES = %w[project_manager normal_user] # for project managers to promote/demote
  ONLY_ROLE = %w[normal_user] # for a normal user creating another normal user
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES, :message => "^Nonexistent role."
  # validates_presence_of :actor_role
  # validates_inclusion_of :actor_role, :in => ACTOR_ROLES, :message => "^Nonexistent actor role."
  
  
  validate :email_formatted_correctly

  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :locations
  
  after_create :create_memberships_for_site_admins
  
  def create_memberships_for_site_admins
    if role == 'site_admin'
      Project.all.each do |p|
        Membership.find_or_create_by_user_id_and_project_id(self.id, p.id)
      end
    end
  end
  
  def folders
  end
  
  # Returns an array of documents that this user has access to
  # def documents
  #   docs = [ ]
  #   self.projects.each { |project|
  #     project.documents.each do |doc|
  #       docs << doc
  #     end
  #     project.folders.each do |folder|
  #       folder.documents.each do |doc|
  #         docs << doc
  #       end
  #     end
  #   }
  #   docs
  # end
  
  # Setter method used by jQuery token input
  def project_tokens=(ids)
    self.project_ids = ids.split(",")
  end
  
  # Random 6-char password
  def self.generate_password
    ActiveSupport::SecureRandom.base64(6)
  end

  def is_member_of?(project)
    return self.memberships.any? { |m| m.project == project }
  end

  def self.authenticate(login, password)
    begin
      user = find(login)
    rescue ActiveRecord::RecordNotFound
      user = find_by_email(login)
    end

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def to_s
    self.email
  end

  # http://guides.rubyonrails.org/active_record_validations_callbacks.html
  def email_formatted_correctly
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not a valid email")
    end
  end

  # For the current user, gets items without locations within the specified project
  # Used in after_filters within projects controller and folders controller for lazy loading
  def get_items_without_locations project
    arr = [ ]
    project.documents.each { |doc|
      arr.push doc if doc.location.nil? # doc.location returns nil if current user does not have a location for the doc
    }
    # add folders...
    return arr
  end
end
