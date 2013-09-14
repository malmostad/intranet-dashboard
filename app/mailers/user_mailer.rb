# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base

  def switchboard_changes(user, message)
    @user = user
    @message = message
    mail to: "Televäxeln <#{APP_CONFIG["switchboard_email"]}>",
         from: "#{@user.first_name} #{@user.last_name} <#{@user.email}>",
         subject: "Adressändring"
  end
end
