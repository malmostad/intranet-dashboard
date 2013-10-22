# -*- coding: utf-8 -*-
require "spec_helper"

describe "GroupContactsAPI" do
  let(:api_app) { ApiApp.create(name: "x", contact: "x", ip_address: "127.0.0.1") }
  let(:group_contact) { create(:group_contact) }

  it "should require authentication" do
    get "/api/v1/group_contacts/123"
    expect(response.status).to eq(401)
    get "/api/v1/group_contacts/search"
    expect(response.status).to eq(401)
  end

  it "should have an unauthorized message" do
    get "/api/v1/group_contacts/123"
    expect(json["message"]).to eq("401 Unauthorized. Your app_token, app_secret or ip address is not correct")
  end

  it "should require valid app_token" do
    get "/api/v1/group_contacts/#{group_contact.id}?app_token=x&app_secret=#{api_app.app_secret}"
    expect(response.status).to eq(401)
  end

  it "should require valid app_token" do
    get "/api/v1/group_contacts/#{group_contact.id}?&app_secret=#{api_app.app_secret}"
    expect(response.status).to eq(401)
  end

  it "should require valid app_secret" do
    get "/api/v1/group_contacts/#{group_contact.id}?app_token=#{api_app.app_token}&app_secret=x"
    expect(response.status).to eq(401)
  end

  it "should require valid app_secret" do
    get "/api/v1/group_contacts/#{group_contact.id}?app_token=#{api_app.app_token}"
    expect(response.status).to eq(401)
  end

  it "should require valid ip address" do
    a = ApiApp.create(name: "x", contact: "x", ip_address: "127.0.0.2")
    get "/api/v1/group_contacts/#{group_contact.id}?app_token=#{a.app_token}&app_secret=#{a.app_secret}"
    expect(response.status).to eq(401)
  end

  describe "search response" do
    it "should be a success" do
      get "/api/v1/group_contacts/search?term=#{group_contact.id}&app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
      expect(response).to be_success
    end

  #   it "should contain one employee" do
  #     get "/api/v1/group_contacts/search?term=#{group_contact.id}&app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #     expect(json.size).to eq(1)
  #   end

  #   it "should not contain any employee" do
  #     get "/api/v1/group_contacts/search?term=foo&app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #     expect(json.size).to eq(0)
  #   end

  #   it "should contain two group_contacts" do
  #     create(:user, username: "foo-1")
  #     create(:user, username: "foo-2")
  #     get "/api/v1/group_contacts/search?term=foo-&app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #     expect(json.size).to eq(2)
  #   end

  #   describe "first matching employee" do
  #     before(:each) do
  #       get "/api/v1/group_contacts/search?term=#{group_contact.id}&app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #     end

  #     it "should have an id" do
  #       expect(json.first["id"]).to eq(group_contact.id)
  #     end

  #     it "should have a first_name" do
  #       expect(json.first["firstName"]).to eq(group_contact.first_name)
  #     end

  #     it "should have an last_name" do
  #       expect(json.first["lastName"]).to eq(group_contact.last_name)
  #     end

  #     it "should have a title" do
  #       expect(json.first["title"]).to eq(group_contact.title)
  #     end

  #     it "should have an email" do
  #       expect(json.first["email"]).to eq(group_contact.email)
  #     end

  #     it "should have a company" do
  #       expect(json.first["company"]).to eq(group_contact.company)
  #     end

  #     it "should have a department " do
  #       expect(json.first["department"]).to eq(group_contact.department)
  #     end

  #     it "should not give away private attributes" do
  #       %w(
  #         statusMessage
  #         admin
  #         createdAt
  #         updatedAt
  #         lastLogin
  #         statusMessageUpdatedAt
  #         earlyAdopter
  #         twitter
  #         skype
  #         privateBio
  #         managerId
  #         homepage
  #         cmgId
  #         deactivated
  #         deactivatedAt
  #       ).each do |attribute|
  #         expect(json.first[attribute]).to eq(nil)
  #       end
  #     end
  #   end
  # end

  # describe "response" do
  #   before(:each) do
  #     get "/api/v1/group_contacts/#{group_contact.id}?app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #   end

  #   it "should be a success" do
  #     expect(response).to be_success
  #   end

  #   it "should return employee id" do
  #     expect(json["id"]).to eq(group_contact.id)
  #   end

  #   it "should return employee catalogId" do
  #     expect(json["catalogId"]).to eq(group_contact.id)
  #   end

  #   it "should return employee firstName" do
  #     expect(json["firstName"]).to eq(group_contact.first_name)
  #   end

  #   it "should return employee catalogId" do
  #     expect(json["lastName"]).to eq(group_contact.last_name)
  #   end

  #   it "should return employee title" do
  #     expect(json["title"]).to eq(group_contact.title)
  #   end

  #   it "should return employee email" do
  #     expect(json["email"]).to eq(group_contact.email)
  #   end

  #   it "should return employee phone" do
  #     expect(json["phone"]).to eq(group_contact.phone)
  #   end

  #   it "should return employee cellPhone" do
  #     expect(json["cellPhone"]).to eq(group_contact.cell_phone)
  #   end

  #   it "should return employee company" do
  #     expect(json["company"]).to eq(group_contact.company)
  #   end

  #   it "should return employee department" do
  #     expect(json["department"]).to eq(group_contact.department)
  #   end

  #   it "should return employee address" do
  #     expect(json["address"]).to eq(group_contact.address)
  #   end

  #   it "should return employee room" do
  #     expect(json["room"]).to eq(group_contact.room)
  #   end

  #   it "should return employee roles array" do
  #     expect(json["roles"].class).to eq(Array)
  #   end

  #   it "should not give away private attributes" do
  #     %w(
  #       statusMessage
  #       admin
  #       createdAt
  #       updatedAt
  #       lastLogin
  #       statusMessageUpdatedAt
  #       earlyAdopter
  #       twitter
  #       skype
  #       privateBio
  #       managerId
  #       homepage
  #       cmgId
  #       deactivated
  #       deactivatedAt
  #     ).each do |attribute|
  #       expect(json[attribute]).to eq(nil)
  #     end
  #   end
  # end

  # it "should return response by user id" do
  #   get "/api/v1/group_contacts/#{group_contact.id}?app_token=#{api_app.app_token}&app_secret=#{api_app.app_secret}"
  #   pending("implement feature")
  #   # expect(response).to be_success
  #   # expect(json["id"]).to eq(group_contact.id)
  #   # expect(json["catalogId"]).to eq(group_contact.id)
  #   # expect(json["firstName"]).to eq(group_contact.first_name)
  #   # expect(json["lastName"]).to eq(group_contact.last_name)
  end
end
