# -*- coding: utf-8 -*-

# Aastra CMG is the switchboard phone catalog and CWI is its SOAP API
# We map employees in the dashboard to CMG records with #get_cmg_id and
# use #activities to get the activities for an employee

class AastraCWI

  CLIENT_SETTINGS = {
    pretty_print_xml: Rails.env.development?,
    # open_timeout: 1,
    # read_timeout: 1,
    log_level: Rails.configuration.log_level,
    logger: Rails.logger,
    log: false # Rails.env.development? # turns of HTTPI logging if false
  }

  # Search for an employee by the LDAP id.
  # Return the employees ID in CMG or nil
  def self.get_cmg_id(user)
    return 0 if user.phone.blank?
    search_client = client(APP_CONFIG['aastra_cwi']['user_service'])

    cmg_phone = user.phone.gsub(/\s/, "")[-5, 5]
    return 0 if cmg_phone == "41000" # switchboard number

    begin
      users = search_client.call(:get_user_information,
        message: {
          "theSearchRequest" => {
            "SearchKeys" => {
              # "string" => "MISC8=#{user.username}",
              # "string" => "MSGID=#{user.email}",
              "string" => "TELNO=#{cmg_phone}"
            },
            "GetFieldNames" => 1
          }
        }
      )
      users.to_array(:get_user_information_response, :get_user_information_result, :subscribers, :subscriber).first[:cmg_id]
    rescue
      0
    end
  end

  # Get the record for a known employee by CMG id, except activities
  def self.find(cmg_id)
    search_client = client(APP_CONFIG['aastra_cwi']['user_service'])
    user = search_client.call(:get_user_information_by_id,
      message: {
        "theSearchRequest" => {
          "RecordId" => cmg_id,
          "ShowInfoActivity" => true,
          "Lang" => "SVE"
        }
      }
    )
  end

  # Get activities for a known employee by CML id
  def self.activities(cmg_id)
    return [] if cmg_id == "0"
    begin
      acitvities_client = client(APP_CONFIG['aastra_cwi']['activity_service'])
      user = acitvities_client.call(:get_activity_information_by_user_id,
        message: {
          "theSearchRequest" => {
            "SearchKey" => "CMGId",
            "KeyValue" => cmg_id,
            "Lang" => "SVE"
          }
        }
      )
      events = user.to_array(:get_activity_information_by_user_id_response, :get_activity_information_by_user_id_result, :activities, :activity)
    rescue
      return []
    end

    events.map! do |event|
      begin
        starting = Time.parse event[:from_date_time]
        ending = Time.parse event[:to_date_time]
        # Does the event occur today?
        if starting < Time.now.end_of_day && ending > Time.now
          OpenStruct.new(
            starting: starting,
            ending: ending,
            reason: event[:reason],
            absent: event[:absent]
          )
        else
          nil
        end
      rescue
        # No time in time fields from Aastra, prbably just a string like "TV"
        OpenStruct.new(
          starting: event[:from_date_time],
          ending: event[:to_date_time],
          reason: event[:reason],
          absent: event[:absent]
        )
      end
    end
    events.compact
  end

  private
    # There are serveral wsdl endpoints, each one needs its own savon client
    def self.client(wsdl)
      client = Savon.client({
        wsdl: wsdl,
        soap_header: { "urn:CommonHeader" => {
            "urn:AnAToken!" => "<![CDATA[#{auth_token}]]>"
          }
        },
        namespace_identifier: "urn",
        convert_request_keys_to: :none
      }.merge(CLIENT_SETTINGS))
    end

    # Fetch and cache the auth token required to
    def self.auth_token
      Rails.cache.fetch('aastra_auth_token', expires_in: 1.day) do
        auth_client = Savon.client({ wsdl: APP_CONFIG['aastra_cwi']["auth_service"] }.merge(CLIENT_SETTINGS))

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
