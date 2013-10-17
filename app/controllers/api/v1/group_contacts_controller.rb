module Api
  module V1
    class GroupContactsController < ApiController
      before_filter :restrict_access
      respond_to :json

      def search
        @limit = 100
        @group_contacts = GroupContact.search(params[:term], @limit)
      end

      def show
        @group_contact = GroupContact.find(params[:id])
      end
    end
  end
end