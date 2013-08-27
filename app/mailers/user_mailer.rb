class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.change_room.subject
  #
  def change_room
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.change_streetaddress.subject
  #
  def change_streetaddress
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
