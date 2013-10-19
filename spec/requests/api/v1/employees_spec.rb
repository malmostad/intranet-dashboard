# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Employees API" do
  it "should require authentication" do
    get '/api/v1/employees/123'
    expect(response.status).to eq(401)
  end

  it "should have an unauthorized message" do
    get '/api/v1/employees/123'
    expect(json['message']).to eq("401 Unauthorized. Your app_token, app_secret or ip address is not correct")
  end
end
