require 'net/imap'
require 'cgi'
require 'oauth'

module Google
  # Extention to IMAP authentication for Googles 2-legged xoauth
  # Ruby IMAP is executing process() when the auth is made
  class IMAPXOAuth

    # mandatory args: {:user => 'username'}, the google username without the domain
    def initialize(args = {})
      user_email = "#{args[:username]}@#{args[:consumer_key]}"

      @options = {
        :user_email => user_email,
        :request_url => "https://mail.google.com/mail/b/#{user_email}/imap/?xoauth_requestor_id=#{CGI.escape(user_email)}",
        :method => 'GET'
      }.merge(args)
    end

    # Build the SASL request
    def process(data)
      @options[:method] + ' ' + @options[:request_url] + ' ' + oauth_params()
    end

    def oauth_params()
      params = {
        "oauth_consumer_key"     => @options[:consumer_key],
        'oauth_nonce'            => OAuth::Helper.generate_key,
        "oauth_signature_method" => 'HMAC-SHA1',
        'oauth_timestamp'        => OAuth::Helper.generate_timestamp,
        'oauth_version'          => '1.0'
      }

      params_for_signing = params.dup
      params_for_signing["xoauth_requestor_id"] = @options[:user_email]

      request = OAuth::RequestProxy.proxy(
        'method'     => @options[:method],
        'uri'        => @options[:request_url],
        'parameters' => params_for_signing
      )

      params['oauth_signature'] =
        OAuth::Signature.sign(
          request,
          :consumer_secret => @options[:consumer_secret],
          :token_secret    => @options[:token_secret]
        )

      params.map { |k,v| "#{k}=\"#{OAuth::Helper.escape(v)}\"" }.sort.join(',')
    end
  end
  Net::IMAP.add_authenticator 'XOAUTH', IMAPXOAuth
end
