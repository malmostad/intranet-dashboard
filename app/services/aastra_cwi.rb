# -*- coding: utf-8 -*-
class AastraCWI

  def auth_token
    # Fetch and cache the auth token required to query CWI
    Rails.cache.fetch('aastra_auth_token', expires_in: 1.day) do
      auth_client = Savon.client(
        wsdl: APP_CONFIG['aastra_cwi']["auth_service"],
        pretty_print_xml: true
      )

      auth = auth_client.call(:get_sso_token,
        message: {
          "username" => APP_CONFIG['aastra_cwi']["username"],
          "password" => APP_CONFIG['aastra_cwi']["password"]
        }
      )

      auth.to_array(:get_sso_token_response).first[:get_sso_token_result]
    end
  end
end
