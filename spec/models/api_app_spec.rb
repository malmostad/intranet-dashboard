require 'spec_helper'

describe ApiApp do
  it "should be created" do
    expect { create(:api_app) }.to change(ApiApp, :count).by(+1)
  end

  it "should be valid" do
    expect(build(:api_app)).to be_valid
  end

  it "should require a name" do
    expect(build(:api_app, name: "")).not_to be_valid
  end

  it "should require a contact" do
    expect(build(:api_app, contact: "")).not_to be_valid
  end

  it "should require an IP address" do
    expect(build(:api_app, ip_address: "")).not_to be_valid
  end

  it "should have a generated app_token" do
    expect(create(:api_app).app_token.length).to be(32)
  end

  it "should have a generated app_secret" do
    expect(create(:api_app).app_secret.length).to be(32)
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
