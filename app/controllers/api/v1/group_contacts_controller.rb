module Api
  module V1
    class GroupContactsController < ApiController
      before_filter :restrict_access
      respond_to :json

      def search
        paginate
        @group_contacts = GroupContact.search(params[:q], @limit, @offset)
      end

      def show
        @group_contact = GroupContact.find(params[:id])
        @group_contact.update_attributes(last_request: Time.now, last_request_by: @api_app.id)
      end
    end
  end
end