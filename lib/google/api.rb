# -*- coding: utf-8 -*-

require 'oauth'

module Google
  class API

    # Mandatory: :consumer_key, :consumer_secret, :username, :api_version
    def initialize(args = {})
      @options = {
        :api_version => '3.0',
        :xoauth_requestor_id => "#{args[:username]}@#{args[:consumer_key]}",
      }.merge(args)
      @client = Google::Client.new(oauth_access_token, @options[:api_version])
    end

    private
    def oauth_access_token
      oauth_consumer = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret])
      OAuth::AccessToken.new(oauth_consumer)
    end
  end
end
