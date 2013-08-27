class UserMailer < ActionMailer::Base
  default from: "noreploy@malmo.se"

  def change_address(user)
    @user = user
    mail to: "televaxeln@malmo.se, serviceforvaltningen.televaxeln@malmo.se"
  end
end
