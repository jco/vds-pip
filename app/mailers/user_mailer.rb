class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def welcome_email(user, generated_password)
    @user = user
    @generated_password = generated_password
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
