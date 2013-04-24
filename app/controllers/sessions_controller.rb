# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  before_filter { add_body_class('login') }

  def new
    # Establish a user session if the user_agent cookie satisfy the remember me criterias
    @user_agent = UserAgent.where(id: cookies.signed[:user_agent][:id] ).first

    if @user_agent.present? && @user_agent.authenticate( cookies.signed[:user_agent][:token] )
      session[:user_id] = @user_agent.user_id
      @user_agent.user.update_attribute("last_login", Time.now)

      set_profile_cookie
      redirect_to root_url

    elsif APP_CONFIG['auth_method'] == "saml"
      redirect_to saml_new_path # SAML Auth has its own controller
    else
      # Render the standard login form
      render :new
    end
  end

  def create
    @user = Authentication.authenticate(params[:username], params[:password])
    if @user
      @user.update_attribute("last_login", Time.now)
      track_user_agent(@user)
      session[:user_id] = @user.id
      set_profile_cookie
      redirect_to root_url
    else
      @login_failed = "Fel användarnamn eller lösenord. Vänligen försök igen."
      render "new"
    end
  end

  def destroy
    begin
      @user_agent = UserAgent.find(cookies.signed[:user_agent][:id])
      @user_agent.update_attributes( remember_me: false )
    rescue
      logger.warn { "'Remember me' for user #{current_user.id} couldn't be reset on logout" }
    end
    session[:user_id] = nil
    redirect_to root_url, notice: "Nu är du utloggad"
  end

  def track_user_agent(user)
    tracker = UserAgent.track(user.id, cookies.signed[:user_agent], params[:remember_me], request.env['HTTP_USER_AGENT'] )
    # Set/update a cookie that keep tracks of this, and only this, user agent
    cookies.permanent.signed[:user_agent] = {
      value:  { id: tracker[:id], token: tracker[:token] },
      secure: !Rails.env.development?,
      path: root_path
    }
  end
end

