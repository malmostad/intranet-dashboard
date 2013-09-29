# rails g scaffold api_app name contact app_token:index ip_address password_digest --skip-assets

class ApiApp < ActiveRecord::Base
  attr_accessible :contact, :ip_address, :name

  has_secure_password
  alias_attribute :app_secret, :password # because `app_secret` is a better name in the api

  before_validation :generate_app_token, :generate_app_secret, on: :create
  validates_presence_of :name, :contact, :ip_address

  def generate_app_secret
    self.password = SecureRandom.hex
  end

  private
    def generate_app_token
      begin
        self.app_token = SecureRandom.hex
      end while self.class.exists?(app_token: app_token)
    end
end
