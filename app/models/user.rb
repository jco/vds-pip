class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :memberships
  
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
