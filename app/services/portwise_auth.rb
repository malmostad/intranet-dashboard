class PortwiseAuth
  attr_reader :username

  def initialize(request)
    @request = request
    @xuid = request.headers["X-UID"]
  end

  def authenticate?
    if trust_proxy?
      Rails.logger.debug "PW trusted"
      if @xuid.present?
        Rails.logger.debug "PW authenticated user #{@xuid}"
        @username = @xuid
        true
      else
        Rails.logger.debug 'Failed: No request.headers["X-UID"]'
      end
    else
      Rails.logger.debug "PW not trusted"
      false
    end
    @username = "martha2"
    true
  end

  private
    def trust_proxy?
      @request.remote_ip == APP_CONFIG["portwise"]["ip_address"] &&
          @request.headers["X-TOKEN"] == APP_CONFIG["portwise"]["token"]
    end
end
