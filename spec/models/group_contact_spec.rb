require 'spec_helper'

describe GroupContact do
  it "should be created" do
    expect { create(:group_contact) }.to change(GroupContact, :count).by(+1)
  end

  it "should be valid" do
    expect(build(:group_contact)).to be_valid
  end

  it "should require a name" do
    expect(build(:group_contact, name: "")).not_to be_valid
  end

  it "should have a protocol for the homepage" do
    g = create(:group_contact, homepage: "malmo.se")
    expect(g.homepage).to eq "http://malmo.se"
  end

  it "should have a correct dash in phone" do
    g = create(:group_contact, phone: "040 - 34 10 00")
    expect(g.phone).to eq "040-34 10 00"
  end

  it "should be destroyed" do
    group_contact = create(:group_contact)
    expect { group_contact.destroy }.to change(GroupContact, :count).by(-1)
  end
end
