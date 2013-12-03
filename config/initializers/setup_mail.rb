ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain              => "binger.herokuapp.com",
  :user_name            => "bingle.yu@gmail.com",
  :password             => "foforwgqvkcegtuh",
  :authentication       => "plain",
  :enable_starttls_auto => true,
  :openssl_verify_mode => 'none'
}