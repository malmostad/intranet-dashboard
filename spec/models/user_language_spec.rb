# -*- coding: utf-8 -*-
require 'spec_helper'

describe UserLanguage do
  let(:language) { create(:language) }
  let(:user) { create(:user) }

  it "should associate a language to a user" do
    UserLanguage.create(user_id: user.id, language_id: language.id)
    expect(user.languages).to be_present
  end

  it "should remove the association of language on destroy" do
    language.destroy
    expect(user.languages).not_to be_present
  end
end
