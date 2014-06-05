module Vcard
  extend ActiveSupport::Concern

  included do
    def to_vcard
      vcard = VCardigan.create
      vcard.name last_name, first_name
      vcard.fullname displayname
      vcard.photo "https://webapps06.malmo.se/avatars/#{username}", type: 'uri'
      vcard.email email, type: ['work', 'internet'], preferred: 1
      vcard[:item1].url 'https://webapps06.malmo.se/dashboard'
      vcard[:item1].label 'URL'
      vcard.to_s
    end
  end

  module ClassMethods
  end
end
