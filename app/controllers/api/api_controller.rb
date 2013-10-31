module Api
  class ApiController < ApplicationController
      private
      # Authentication for API calls using ApiApp.authenticate
      # Use as a callback with before_filter/before_action
      def restrict_access
        @api_app = ApiApp.authenticate(params["app_token"], params["app_secret"], request.remote_ip)
        unless @api_app
          render json: {
            message: "401 Unauthorized. Your app_token, app_secret or ip address is not correct" },
          status: :unauthorized
        end
      end

      # Used for searches
      # Takes `per_page` and `page` query params
      # Defines @limit and @offset
      def paginate
        @limit = params[:per_page].present? ? params[:per_page].to_i : 100
        @limit = 100 if @limit > 100 # Miximum allowed
        page = params[:page].present? ? (params[:page].to_i - 1) : 0
        @offset = page * @limit
      end
  end
end