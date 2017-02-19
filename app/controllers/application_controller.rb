# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery unless: :js_not_found
  before_action :init_body_class, :mailer_set_url_options

  # Don't log javascript 404:s as CORS errors
  def js_not_found
    if params["format"] == "js" && params["not_found"].present?
      log_response_not_found
      render js: "", status: 406
      return true
    else
      return false
    end
  end

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
        hr_department: current_user.company,
        # Singular is for GA
        department:   departments.present? ? departments.first[:homepage_url].gsub('http://komin.malmo.se/', '') : '',
        workingfield: workingfields.present? ? workingfields.first[:homepage_url].gsub('http://komin.malmo.se/', '') : '',
        # Plural for masthead w/dropdowns
        departments:   departments,
        workingfields: workingfields,
        ua: Digest::MD5.hexdigest(
          current_user.id.to_s +
          current_user.username +
          current_user.created_at.to_i.to_s
        )
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
    tracker = UserAgent.track(current_user.id, tracker_id, params[:remember_me], request.env['HTTP_USER_AGENT'])

    # Set tracker in browser
    cookies.permanent.signed[:user_agent] = {
      value:  { id: tracker[:id], token: tracker[:token] },
      secure: !Rails.env.development?,
      httponly: true,
      path: root_path
    }
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from StandardError do |exception|
      if exception.is_a?(ArgumentError) && exception.message == "invalid byte sequence in UTF-8"
        # Silent rescue from IE9 UTF-8 url hacking bug, strip query and redirect to requested resource
        logger.warn "<=IE9 UTF-8 bug rescued"
        redirect_to controller: params[:controller], action: params[:action]
      else
        server_error(exception.message)
      end
    end
    rescue_from ActionController::RoutingError,
        ActionController::UnknownController,
        ::AbstractController::ActionNotFound,
        ActiveRecord::RecordNotFound,
      with: lambda { |exception| not_found(exception) }
  end

  protected

  def current_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      false
    end
  end
  helper_method :current_user

  def contacts_editor?
    current_user && (current_user.contacts_editor? || current_user.admin?)
  end
  helper_method :contacts_editor?

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?

  def require_user
    if !current_user
      if !request.xhr?
        session[:requested] = { url: request.fullpath, at: Time.now }
      end
      redirect_to login_path
    end
  end

  def require_admin
    not_authorized unless admin?
  end

  def require_contacts_editor
    not_authorized unless contacts_editor?
  end

  def require_early_adopter
    not_authorized unless current_user && current_user.early_adopter?
  end

  # Use only when params[:id] is users id
  def editing_myself?
    current_user.id.to_i === params[:id].to_i
  end

  def require_admin_or_myself
    not_authorized unless admin? || editing_myself?
  end

  def require_admin_or_contacts_editor_or_myself
    not_authorized unless admin? || editing_myself? || contacts_editor?
  end

  def not_authorized(msg = "Du saknar behörighet för detta" )
    flash[:error] = msg
    redirect_to root_path
  end

  def redirect_after_login
    if session[:requested] && session[:requested][:at] > 10.minutes.ago
      requested_url = session[:requested][:url]
      session[:requested] = nil
      redirect_to requested_url
    else
      redirect_to root_path
    end
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

  def sub_layout(name = "", options = {})
    @sub_layout = name unless options[:except] == params[:action]
  end

  # Error responses are triggered both from rescue_from and routing match with errors controller
  def not_found(exception = "Sidan kunde inte hittas")
    log_response_not_found
    sub_layout(false)
    respond_to do |format|
      format.html { render template: "errors/error_404", status: 404 }
      format.json { render json: { response: "Not Found", status: 404 }, status: 404 }
      format.all  { render text: "", status: 406 }
    end
  end

  def server_error(exception = "Ett fel inträffade")
    log_response_error(500, exception)
    sub_layout(false)
    respond_to do |format|
      format.html { render template: "errors/error_500", status: 500}
      format.json { render json: { response: "Server Error", status: 500 }, status: 500 }
      format.all  { render text: "", status: 500 }
    end
  end

  def log_response_error(response, exception = "")
    logger.error "Error: #{exception}"
    logger.error "  Response code: #{response}"
    logger.error "  Full path: #{request.fullpath}"
    logger.error "  User id: #{session[:user_id] ? (session && session[:user_id]) : 'anonymous'}"
    logger.error "  User Agent: #{request.user_agent}"
    logger.error "  Referer: #{request.referer}"
    logger.error "  Params: #{params.except(:password)}"
  end

  def log_response_not_found
    logger.info "404 Not Found"
    logger.info "  User id: #{session[:user_id] ? (session && session[:user_id]) : 'anonymous'}"
    logger.info "  Full path: #{request.fullpath}"
    logger.info "  Referer: #{request.referer}"
    logger.info "  Params: #{params.except(:password)}"
  end

  # It is not possible to set a /path mounted app url in the
  # action mailer config so we need to do it here
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.env["HTTP_HOST"] + root_path.slice(0..-2)
  end
end
