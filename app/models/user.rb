#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :role, :project_tokens
  attr_reader :project_tokens # http://railscasts.com/episodes/258-token-fields
  
  attr_accessible :project_ids # needed for check box forms in users _form, when a normal user creates another user
  attr_accessor :password
  before_save :encrypt_password
  
  ROLES = %w[site_admin project_manager normal_user]
  MINOR_ROLES = %w[project_manager normal_user] # for project managers to promote/demote
  ONLY_ROLE = %w[normal_user] # for a normal user creating another normal user
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES, :message => "^Nonexistent role."
  
  has_many :memberships
  has_many :projects, :through => :memberships
  
  # Setter method used by jQuery token input
  def project_tokens=(ids)
    self.project_ids = ids.split(",")
  end
  
  # What is this? I think we can get rid of it since I finished the has_many through relationship. -David
  # def projects
  #   memberships.map {|membership| membership.project }
  # end
  
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
end
