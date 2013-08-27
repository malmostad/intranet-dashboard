# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base

  def change_address(user)
    # @message = params[:message]
    @user = user
    mail to: "Televäxeln <#{APP_CONFIG["switchboard_email"]}>",
         from: "#{@user.first_name} #{@user.last_name} <#{@user.email}>",
         subject: "Adressändring"
  end
end
