# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_body_class

  # Set a permanent cookie w/data from the user profile. Used by the masthead in other webapps
  def set_profile_cookie
    departments = current_user.roles.map { |d| { name: d.name, homepage_url: d.homepage_url } if d.category == 'department' }.compact
    workingfields = current_user.roles.map { |w| { name: w.name, homepage_url: w.homepage_url } if w.category == 'working_field' }.compact

    if Rails.env.development?
      myprofile = "myprofile-development"
    elsif Rails.env.test?
      myprofile = "myprofile-test"
    else
      myprofile = "myprofile"
    end

    cookies.permanent[myprofile] = {
      value: {
        # Singular is for old style masthead
        department:   departments.present? ? departments.first[:homepage_url].gsub('http://komin.malmo.se/', '') : '',
        workingfield: workingfields.present? ? workingfields.first[:homepage_url].gsub('http://komin.malmo.se/', '') : '',
        # Plural for masthead w/dropdowns
        departments:   departments,
        workingfields: workingfields
      }.to_json,
      expires: 365*10,
      path: '/',
      domain: 'malmo.se'
    }
  end

  # Save user agent and set permanent cookie for "remember me"
  def track_user_agent
    # Existing tracker from the browser
    tracker_id = cookies.signed[:user_agent].present? ? cookies.signed[:user_agent][:id] : nil

    # Get or create tracker from the UserAgent model
    tracker = UserAgent.track(current_user.id, tracker_id, params[:remember_me], request.env['HTTP_USER_AGENT'] )

    # Set tracker in browser
    cookies.permanent.signed[:user_agent] = {
      value:  { id: tracker[:id], token: tracker[:token] },
      secure: !Rails.env.development?,
      path: root_path
    }
  end

  # Catch errors and record not founds
  unless Rails.env.development?
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from AbstractController::ActionNotFound, with: :not_found
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Exception, with: :error_page
  end
  def method_missing(method, *args)
    not_found
  end

  def not_found(exception = "404")
    logger.warn "#{exception} #{request.fullpath}"
    reset_body_classes
    render template: "404", status: 404
  end

  def error_page(exception = "500", msg = "Prova att navigera med menyn ovan.")
    logger.error("Exception: #{exception}\n" +
                 "#{' ' * 32 }User id: #{user? ? session[:user_id] : 'anonymous'}\n" +
                 "#{' ' * 32 }Params: #{params}")
    reset_body_classes
    @msg = msg
    render template: "500", status: 500
  end

  protected

  def user?
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if user?
  end

  def admin?
    user? and current_user.is_admin
  end

  def require_user
    redirect_to login_path unless user?
  end
  helper_method :user?, :admin?, :current_user

  def require_admin
    not_authorized unless admin?
  end

  # Use only when params[:id] is users id
  def editing_myself?
    current_user.id.to_i === params[:id].to_i
  end
  helper_method :editing_myself?

  def require_admin_or_myself
    not_authorized unless admin? or editing_myself?
  end

  def not_authorized(msg = "Du saknar behörighet för detta" )
    flash[:error] = msg
    redirect_to root_path
  end

  def init_body_class
    add_body_class(Rails.env)
    add_body_class('malmo-masthead-dashboard')
    add_body_class("user") if current_user
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ""
    @body_classes << "#{name} "
  end

  def reset_body_classes
    @body_classes = nil
    init_body_class
  end

  def sub_layout(name = "")
    @sub_layout = name
  end

  def avatar_full_url(username, style = :medium_quadrat)
    "#{request.protocol}#{File.join(APP_CONFIG['avatar_base_url'], username, style.to_s)}.jpg"
  end
  helper_method :avatar_full_url
end
