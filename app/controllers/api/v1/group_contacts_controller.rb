module Api
  module V1
    class GroupContactsController < ApiController
      before_filter :restrict_access
      respond_to :json

      def search
        paginate
        @group_contacts = GroupContact.search(params[:term], @limit, @offset)
      end

      def show
        @group_contact = GroupContact.find(params[:id])
      end
    end
  end
end