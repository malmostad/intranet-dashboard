# -*- coding: utf-8 -*-
require "spec_helper"

describe "Employees API" do
  let(:api_app) { ApiApp.create(name: "x", contact: "x", ip_address: "127.0.0.1") }
  let(:user) { create(:user) }

  it "should require authentication" do
    get "/api/v1/employees/123"
    expect(response.status).to eq(401)
    get "/api/v1/employees/search"
    expect(response.status).to eq(401)
  end

  it "should have an unauthorized message" do
    get "/api/v1/employees/123"
    expect(json["message"]).to eq("401 Unauthorized. Your app_token, app_secret or ip address is not correct")
  end

  it "should require valid app_token" do
    get "/api/v1/employees/#{user.username}?app_token=x&app_secret=#{api_app.app_secret}"
    expect(response.status).to eq(401)
  end

  it "should require valid app_token" do
    get "/api/v1/employees/#{user.username}?&app_secret=#{api_app.app_secret}"
    expect(response.status).to eq(401)
  end

  it "should require valid app_secret" do
    get "/api/v1/employees/#{user.username}?app_token=#{api_app.app_token}&app_secret=x"
    expect(response.status).to eq(401)
  end

  it "should require valid app_secret" do
    get "/api/v1/employees/#{user.username}?app_token=#{api_app.app_token}"
    expect(response.status).to eq(401)
  end

  it "should require valid ip address" do
    a = ApiApp.create(name: "x", contact: "x", ip_address: "127.0.0.2")
    get "/api/v1/employees/#{user.username}?app_token=#{a.app_token}&app_secret=#{a.app_secret}"
    expect(response.status).to eq(401)
  end

  describe "response" do
    before(:each) do
      get "/api/v1/employees/#{user.username}?app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
    end

    it "should return employee id" do
      expect(json["id"]).to eq(user.id)
    end

    it "should return employee catalogId" do
      expect(json["catalogId"]).to eq(user.username)
    end

    it "should return employee firstName" do
      expect(json["firstName"]).to eq(user.first_name)
    end

    it "should return employee catalogId" do
      expect(json["lastName"]).to eq(user.last_name)
    end

    it "should return employee title" do
      expect(json["title"]).to eq(user.title)
    end

    it "should return employee email" do
      expect(json["email"]).to eq(user.email)
    end

    it "should return employee phone" do
      expect(json["phone"]).to eq(user.phone)
    end

    it "should return employee cellPhone" do
      expect(json["cellPhone"]).to eq(user.cell_phone)
    end

    it "should return employee company" do
      expect(json["company"]).to eq(user.company)
    end

    it "should return employee department" do
      expect(json["department"]).to eq(user.department)
    end

    it "should return employee address" do
      expect(json["address"]).to eq(user.address)
    end

    it "should return employee room" do
      expect(json["room"]).to eq(user.room)
    end

    it "should return employee roles array" do
      expect(json["roles"].class).to eq(Array)
    end

    it "should not give away private attributes" do
      %w(
        statusMessage
        admin
        createdAt
        updatedAt
        lastLogin
        statusMessageUpdatedAt
        earlyAdopter
        twitter
        skype
        privateBio
        managerId
        homepage
        cmgId
        deactivated
        deactivatedAt
      ).each do |attribute|
        expect(json[attribute]).to eq(nil)
      end
    end
  end

  it "should return employee data by user id" do
    get "/api/v1/employees/#{user.id}?app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
    expect(json["id"]).to eq(user.id)
    expect(json["catalogId"]).to eq(user.username)
    expect(json["firstName"]).to eq(user.first_name)
    expect(json["lastName"]).to eq(user.last_name)
  end
end
