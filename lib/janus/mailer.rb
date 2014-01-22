class Janus::Mailer < ActionMailer::Base
  default from: Janus::Config.contact_email

  def reset_password_instructions(user)
    @user = user
    mail :to => @user.email, :subject => I18n.t('janus.mailer.reset_password_instructions.subject')
  end

  def confirmation_instructions(user)
    @user = user
    mail :to => @user.email, :subject => I18n.t('janus.mailer.confirmation_instructions.subject')
  end
end
