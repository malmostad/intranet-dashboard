# -*- coding: utf-8 -*-
class SamlController < ApplicationController

  # Create a SAML request and send the user to the IdP
  def new
    request = Onelogin::Saml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  # Parse the SAML response from the IdP and authenticate the user
  def consume
    response = Onelogin::Saml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    if response.is_valid?
      @user = User.where(username: response.attributes[APP_CONFIG["saml"]["username_key"].to_sym]).first
      if @user
        session[:user_id] = @user.id
        redirect_to root_url
      else
        # TODO: Skapa användaren
        render text: "User not in dashboard"
      end
    else
      error_page("500", "Ett fel uppstod med Portwise.")
    end
  end

  def metadata
    meta = Onelogin::Saml::Metadata.new
    render xml: meta.generate(saml_settings)
  end

  private

  def saml_settings
    sc = APP_CONFIG["saml"]
    s = Onelogin::Saml::Settings.new
    s.issuer                         = sc["issuer"]
    s.idp_sso_target_url             = sc["idp_sso_target_url"]
    s.assertion_consumer_service_url = sc["assertion_consumer_service_url"]
    s.idp_cert_fingerprint           = sc["idp_cert_fingerprint"]
    s.name_identifier_format         = sc["name_identifier_format"]
    s.authn_context                  = sc["authn_context"]
    s
  end
end
