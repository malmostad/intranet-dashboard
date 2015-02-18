module Api
  module V1
    # "Employee" is the best term for the api, the internal model name is "User".
    class EmployeesController < ApiController
      before_action :restrict_access

      def search
        paginate
        @employees = User.search(params.except(:controller, :action), @limit, @offset)[:users]
      end

      def show
        # We accept both users id (Integer) and username (String)
        id = Integer(params[:id]) rescue false
        if id
          @employee = User.find(id)
        else
          @employee = User.where(username: params[:id]).first
        end
        unless @employee.present?
          render json: { response: "Not Found", status: 404 }, status: 404
        end
      end
    end
  end
end
