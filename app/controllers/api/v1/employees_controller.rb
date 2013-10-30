module Api
  module V1
    # "Employee" is the best term for the api, the internal model name is "User".
    class EmployeesController < ApiController
      before_filter :restrict_access
      respond_to :json

      def search
        paginate
        @employees = User.search(params.except(:controller, :action), @limit, @offset)
      end

      def show
        # We accept both users id and username
        begin
          @employee = User.find(params[:id])
        rescue
          @employee = User.where(username: params[:id]).first
        end
      end
    end
  end
end