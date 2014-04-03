class Portwise
  attr_reader :username

  def initialize(request)
    @request = request
    @xuid = request.headers["X-UID"]
  end

  def authenticate?
    Rails.logger.debug { "Trying Portwise auth" }
    if trust_proxy?
      if @xuid.present?
        Rails.logger.debug { "Portwise authenticated user #{@xuid}" }
        @username = @xuid
        true
      else
        Rails.logger.warning "Portwise did not send request.headers['X-UID']"
        false
      end
    else
      Rails.logger.debug { "Didn't trust Portwise" }
      false
    end
  end

  def request?
    @xuid.present? && trust_proxy?
  end

  private
    def trust_proxy?
      # Has portwise the correct IP, token and is the request ssl, if forced in config
      @request.remote_ip == APP_CONFIG["portwise"]["ip_address"] &&
          @request.headers["X-TOKEN"] == APP_CONFIG["portwise"]["token"] &&
          (@request.ssl? || !APP_CONFIG["portwise"]["require_ssl"])
    end
end
