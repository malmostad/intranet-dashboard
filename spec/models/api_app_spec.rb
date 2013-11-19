require 'spec_helper'

describe ApiApp do
  it "should be created" do
    expect { create(:api_app) }.to change(ApiApp, :count).by(+1)
  end

  it "should be valid" do
    build(:api_app).should be_valid
  end

  it "should require a name" do
    build(:api_app, name: "").should_not be_valid
  end

  it "should require a contact" do
    build(:api_app, contact: "").should_not be_valid
  end

  it "should require an IP address" do
    build(:api_app, ip_address: "").should_not be_valid
  end

  it "should have a generated app_token" do
    create(:api_app).app_token.length.should be(32)
  end

  it "should have a generated app_secret" do
    create(:api_app).app_secret.length.should be(32)
  end

  it "should be destroyed" do
    api_app = create(:api_app)
    expect { api_app.destroy }.to change(ApiApp, :count).by(-1)
  end

  it "should not be authenticated with incorrect app_token" do
    a = create(:api_app)
    ApiApp.authenticate("x", a.app_secret, a.ip_address)
  end

  it "should not be authenticated with incorrect app_secret" do
    a = create(:api_app)
    ApiApp.authenticate(a.app_token, "x", a.ip_address)
  end

  it "should not be authenticated with incorrect IP address" do
    a = create(:api_app)
    ApiApp.authenticate(a.app_token, a.app_secret, '127.0.0.2')
  end

  it "should not be authenticated with empty app_token" do
    a = create(:api_app)
    ApiApp.authenticate(nil, a.app_secret, a.ip_address)
  end

  it "should not be authenticated with empty app_secret" do
    a = create(:api_app)
    ApiApp.authenticate(a.app_token, nil, a.ip_address)
  end

  it "should not be authenticated with empty IP address" do
    a = create(:api_app)
    ApiApp.authenticate(a.app_token, a.app_secret, nil)
  end

  it "should be authenticated with correct credentials" do
    a = create(:api_app)
    ApiApp.authenticate(a.app_token, a.app_secret, a.ip_address)
  end
end
