module Api
  class ApiController < ApplicationController
      private
      # Authentication for API calls using ApiApp.authenticate
      # Use as a callback with before_filter/before_action
      def restrict_access
        unless ApiApp.authenticate(params["app_token"], params["app_secret"], request.remote_ip)
          render json: {
            message: "401 Unauthorized. Your app_token, app_secret or ip address is not correct" },
          status: :unauthorized
        end
      end
    end
end