class PortwiseAuth
  attr_reader :username

  def initialize(request)
    @request = request
    @xuid = request.headers["X-UID"]
  end

  def authenticate?
    if trust_proxy?
      if @xuid.present?
        Rails.logger.debug { "Portwise authenticated user #{@xuid}" }
        @username = @xuid
        true
      else
        Rails.logger.warning "Portwise did not send request.headers['X-UID'] #{@xuid}"
      end
    else
      Rails.logger.error "Portwise not trusted #{request.headers}"
      false
    end
  end

  private
    def trust_proxy?
      @request.remote_ip == APP_CONFIG["portwise"]["ip_address"] &&
          @request.headers["X-TOKEN"] == APP_CONFIG["portwise"]["token"]
    end
end
