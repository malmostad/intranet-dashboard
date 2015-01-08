# -*- coding: utf-8 -*-
require 'spec_helper'

describe "EmployeeExport" do
  it "should format a VCard" do
    user = create(:user)
    vcard = EmployeeExport.to_vcard(user, "http://example.org/users")
    expect(vcard.split("\n").first).to eq "BEGIN:VCARD"
    expect(vcard.split("\n").last).to eq "END:VCARD"
  end

  it "should format a VCard" do
    users = 1.upto(10).map { create(:user, company: "Example Org") }
    excel_stream = EmployeeExport.group_as_xlsx(users)
    expect(excel_stream[0...2]).to eq "PK" # An xlsx is packed as a zip file
  end
end
