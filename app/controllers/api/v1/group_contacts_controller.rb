module Api
  module V1
    class GroupContactsController < ApiController
      before_action :restrict_access

      def search
        paginate
        @group_contacts = GroupContact.search(params[:q], @limit, @offset)
      end

      def show
        @group_contact = GroupContact.find(params[:id])
        @group_contact.update_attributes(
          requests: @group_contact.requests + 1,
          last_request: Time.now,
          last_request_by: @api_app.id
        )
      end
    end
  end
end
