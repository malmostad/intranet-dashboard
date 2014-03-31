# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  before_filter { add_body_class('login') }

  def new
    if direct_auth?(request) # Portwise or remember me auth
      finalize_login
      redirect_after_login
    elsif APP_CONFIG['auth_method'] == "saml" # SAML Auth has its own controller
      redirect_to saml_new_path
    else # Render the standard form for LDAP login
      render :new
    end
  end

  def create
    if APP_CONFIG['stub_auth'] && Rails.env.development? # Stubbed authentication
      stub_auth(params[:username])
    else # Authenticate with LDAP
      ldap = Ldap.new
      if ldap.authenticate(params[:username], params[:password])
        user = User.unscoped.where(username: username).first_or_initialize
        session[:user_id] = user.id
        finalize_login
        redirect_after_login
      else
        @login_failed = "Fel användarnamn eller lösenord. Vänligen försök igen."
        render "new"
      end
    end
  end

  def destroy
    begin
      # Reset user agent ("remember me" auth)
      user_agent = UserAgent.find(cookies.signed[:user_agent][:id])
      user_agent.update_attributes( remember_me: false )
    rescue
      logger.warn { "'Remember me' for user couldn't be reset on logout" }
    end
    reset_session

    if Portwise.new(request).request?
      redirect_to APP_CONFIG['portwise']['signout_url']
    else
      redirect_to root_url, notice: "Nu är du utloggad"
    end
  end

  private
    def direct_auth?(request)
      if APP_CONFIG['portwise']['enabled'] # Try Portwise authentication
        portwise = Portwise.new(request)
        if portwise.authenticate?
          user = User.unscoped.where(username: username).first_or_initialize
          session[:user_id] = user.id
          return true
        end
      else # Try "remember me" authentication
        user_agent = cookies.signed[:user_agent].present? ?
            UserAgent.where(id: cookies.signed[:user_agent][:id]).first : false
        if user_agent && user_agent.authenticate(cookies.signed[:user_agent][:token])
          session[:user_id] = user_agent.user_id
          return true
        end
      end
      return false
    end

    def finalize_login
      # Update user attributes from LDAP
      Ldap.new.update_user_profile(current_user.username)

      # Update timestamp
      current_user.update_attribute("last_login", Time.now)

      # Set cookies
      set_profile_cookie
      track_user_agent
    end

    def stub_auth(username)
      user = User.where(username: username).first
      if user
        session[:user_id] = user.id
        redirect_after_login
      else
        @login_failed = "Användarnamnet finns inte"
        render "new"
      end
    end
end
