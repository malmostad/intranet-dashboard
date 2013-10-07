module Api
  module V1
    # "Employee" is the best term for the api, the internal model name is "User".
    class EmployeesController < ApiController
      before_filter :restrict_access
      respond_to :json

      def search
        @limit = 100
        page = params[:page].present? ? params[:page].to_i : 0
        @offset = page * @limit
        @employees = User.search(params, @limit, @offset)
      end

      def show
        @employee = User.where(username: params[:username]).first
      end
    end
  end
end