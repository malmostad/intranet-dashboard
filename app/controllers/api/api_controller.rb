module Api
  class ApiController < ApplicationController
      private
      # Authentication for API calls using ApiApp.authenticate
      # Use as a callback with before_filter/before_action
      def restrict_access
        @api_app = ApiApp.authenticate(params["app_token"], params["app_secret"], request.remote_ip)
        if !protocol_ok?
          render json: {
            message: "404 Not Found. (Hey, only HTTPS allowed)",
            documentation_url: "https://github.com/malmostad/intranet-dashboard/wiki/Contacts-API-v1"
            },
          status: :not_found
        elsif !@api_app
          render json: {
            message: "401 Unauthorized. Your app_token, app_secret or ip address is not correct.",
            documentation_url: "https://github.com/malmostad/intranet-dashboard/wiki/Contacts-API-v1"
            },
          status: :unauthorized
        end
      end

      # Used for searches
      # Takes `per_page` and `page` query params
      # Defines @limit and @offset
      def paginate
        @limit = params[:per_page].present? ? params[:per_page].to_i : 25
        @limit = 100 if @limit > 100 # Miximum allowed
        page = params[:page].present? ? (params[:page].to_i - 1) : 0
        @offset = page * @limit
      end

      def protocol_ok?
        if request.protocol == "http://" && (Rails.env.production? || Rails.env.test?)
          return false
        else
          return true
        end
      end
  end
end