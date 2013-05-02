# -*- coding: utf-8 -*-
class SamlController < ApplicationController
  # No CSRF from IdP POST, so disable the check
  skip_before_filter :verify_authenticity_token, only: [:consume]

  # Create a SAML request and send the user to the IdP
  def new
    request = Onelogin::Saml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  # Validate the SAML response from the IdP
  def consume
    begin
      response = Onelogin::Saml::Response.new(params[:SAMLResponse])
      response.settings = saml_settings

      if response.is_valid? && response.success?
        username = response.attributes[APP_CONFIG["saml"]["username_key"].to_sym]

        # Update user attributes from LDAP. Create user if it is her first login.
        @user = Ldap.new.update_user_profile(username)
        @user.update_attribute("last_login", Time.now)

        # Set user cookies
        session[:user_id] = @user.id
        set_profile_cookie
        track_user_agent

        redirect_to root_path
      else
        logger.warn "SAML response not valid for #{username}"
      end
    rescue
      logger.error "SAML response not valid"
      error_page("500", "Ett fel uppstod med Single Sign On-tjänsten.")
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
    s.compress_request               = false
    s
  end
end
