class ApplicationController < ActionController::Base
  protect_from_forgery

  def google_keys
    {
      :consumer_secret => APP_CONFIG[:google_consumer_secret],
      :consumer_key => APP_CONFIG[:google_consumer_key]
    }
  end

  private

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ""
    @body_classes << " user" if current_user
    @body_classes << " #{name}"
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
