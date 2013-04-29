# -*- coding: utf-8 -*-

class SessionsController < ApplicationController

  before_filter { add_body_class('admin') }

  def new
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Du är nu inloggad."
    else
      flash.now[:notice] = "Ogiltigt användarnamn eller lösenord."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Du är nu utloggad."
  end

  def destroy_and_login
    session[:user_id] = nil
    render "new"
  end
end

