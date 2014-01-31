class UserMailer < ActionMailer::Base
  default from: "webmaster@binger.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => "#{user.name} <#{user.email}>", :subject => "Password Reset"
  end
  
  def registration_confirmation(user)
    @user = user
    #attachments["bingerapp.png"] = File.read('#{Rails.root}/app/assets/images/bingerapp.png')
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
end