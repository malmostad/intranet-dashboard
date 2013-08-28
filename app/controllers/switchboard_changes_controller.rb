# -*- coding: utf-8 -*-

# Room and street address is not changed locally, send mail to switchboard
# When the switchboard team change the data in CMG it is synced to the Dashboard

class SwitchboardChangesController < ApplicationController
  before_filter { add_body_class('employee') }
  before_filter :require_user

  def new
  end

  def create
    if params[:room] || params[:streetadress]
      UserMailer.change_address(current_user).deliver
      redirect_to root_path, notice: "Din ändringsbegäran har skickats till televäxeln."
    else
      render action: "new"
    end
  end
end
