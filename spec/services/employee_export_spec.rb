# -*- coding: utf-8 -*-
require 'spec_helper'

describe "EmployeeExport" do
  it "should format a VCard" do
    user = create(:user)
    vcard = EmployeeExport.to_vcard(user, "http://example.org/users")
    vcard.split("\n").first.should eq "BEGIN:VCARD"
    vcard.split("\n").last.should eq "END:VCARD"
  end

  it "should format a VCard" do
    users = 1.upto(10).map { create(:user, company: "Example Org") }
    excel_stream = EmployeeExport.group_as_xlsx(users)
    # excel_stream[0...2].bytes.should eq [80, 75]
    excel_stream[0...2].should eq "PK" # An xlsx is packed as a zip file
  end
end
