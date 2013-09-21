module Api
  module V1

    # "Employee" is the best term for the api, the internal model name is User.
    class EmployeesController < ApplicationController
      respond_to :json

       def search
         @employees = { fox: "barx" }
       end

       def show
         @employee = User.where(username: params[:username]).first
       end
    end
  end
end