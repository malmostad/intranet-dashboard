# Execute Google Data API request
module Google
  class Client

    def initialize(oauth_signature, api_version = '3.0')
      @oauth_signature = oauth_signature
      @api_version = api_version
    end

    def get(base, query_parameters)
      make_request(:get, url(base, query_parameters))
    end

   private

   def make_request(method, url)
      response = @oauth_signature.request(method, url, { 'GData-Version' => @api_version })
      if response.is_a?(Net::HTTPFound)
        url = response['Location']
        return make_request(method, response['Location'])
      end
      return unless response.is_a?(Net::HTTPSuccess)
      response
    end

    def url(base, query_parameters={})
      url = base
      unless query_parameters.empty?
        url += '?'
        query_parameters.each { |key, value|
          url += "#{CGI::escape(key)}=#{CGI::escape(value)}&"
        }
        url.chop!
      end
      url
    end
  end
end
