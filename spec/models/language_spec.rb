# -*- coding: utf-8 -*-
require 'spec_helper'

describe Language do
  it "should be created" do
    expect { create(:language) }.to change(Language, :count).by(+1)
  end

  it "should be valid" do
    build(:language).should be_valid
  end

  it "should require a name" do
    build(:language, name: "").should_not be_valid
  end

  it "should validate the length" do
    build(:language, name: "fox barx" * 10).should_not be_valid
  end

  it "should validate the uniqueness" do
    create(:language, name: "fox")
    build(:language, name: "fox").should_not be_valid
  end

  it "should be destroyed" do
    language = create(:language)
    expect { language.destroy }.to change(Language, :count).by(-1)
  end

  describe "merged into another" do
    before(:each) do
      @language_1 = create(:language)
      @user_1 = create(:user, languages: [@language_1])
      @language_2 = create(:language)
      @user_2 = create(:user, languages: [@language_2])
    end

    it "should destroy the first language" do
      puts Language.count
      puts Language.first
      puts User.count
      puts @user_1
      puts @user_1.languages.first.name
      puts @language_1.users.first.username
      # expect { Language.merge(Language.first.id, Language.limit(2).last.id) }.to change(Language, :count).by(-1)
    end

    it "should not destroy the second language" do
    end

    it "should not change users number of languages" do
      # expect { Language.merge(Language.first.id, Language.limit(2).last.id) }.to change(user_1.languages, :count).by(0)
    end

    it "should not change users number of languages when she has both the old and the new language" do
    end
  end
end
