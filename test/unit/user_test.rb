#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = generate_unsaved_user('UserTestvaliduser@gmail.com')
    assert(user.save, user.errors.inspect)
  end

  test "invalid email" do
    # try to create a user with an invalid email
    user = generate_unsaved_user('notanemail')
    assert(!user.save, "User was saved with an invalid email address")
  end

  test "non-unique email" do
    user1 = generate_unsaved_user('a@b.com')
    assert(user1.save)
    user2 = generate_unsaved_user('a@b.com')
    assert(!user2.save, "User 2 was saved with a duplicate email address")
  end
    
  def generate_unsaved_user(email)
    generated_password = User.generate_password
    User.new(:email => email, :password => generated_password)
  end
    
end
