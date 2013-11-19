require 'spec_helper'

describe GroupContact do
  it "should be created" do
    expect { create(:group_contact) }.to change(GroupContact, :count).by(+1)
  end

  it "should be valid" do
    build(:group_contact).should be_valid
  end

  it "should require a name" do
    build(:group_contact, name: "").should_not be_valid
  end

  it "should have a protocol for the homepage" do
    g = create(:group_contact, homepage: "malmo.se")
    g.homepage.should eq("http://malmo.se")
  end

  it "should have a correct dash in phone" do
    g = create(:group_contact, phone: "040 - 34 10 00")
    g.phone.should eq("040-34 10 00")
  end

  it "should be destroyed" do
    group_contact = create(:group_contact)
    expect { group_contact.destroy }.to change(GroupContact, :count).by(-1)
  end
end
