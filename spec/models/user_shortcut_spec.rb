# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users shortcuts" do
  let(:shortcut) { create(:shortcut) }
  let(:user) { create(:user) }

  it "should associate a shortcut to a user" do
    user.shortcuts << shortcut
    expect(user.shortcuts).to be_present
  end

  it "should not destroy the shortcut when removed from user" do
    user.shortcuts.delete(shortcut)
    expect(shortcut).to be_present
  end

  it "should remove the association of shortcut on destroy" do
    shortcut.destroy
    expect(user.shortcuts).not_to be_present
  end

  describe "attached from roles" do
    before(:all) {
      @shortcut = create(:shortcut)
      @role = create(:role)
      @role.shortcuts << @shortcut
    }

    it "role should have a shortcut" do
      expect(@role.shortcuts).to be_present
    end

    it "user should not have a shortcut" do
      user = create(:user)
      expect(user.shortcuts).not_to be_present
    end

    it "user should get a shortcut from the role" do
      user = create(:user, roles: [@role])
      user.add_shortcuts_from_roles(@shortcut.category)
      expect(user.shortcuts).to be_present
    end

    it "user should get a shortcut from the role on reset" do
      user = create(:user, roles: [@role])
      user.reset_shortcuts_in_category(@shortcut.category)
      expect(user.shortcuts).to be_present
    end
  end
end
