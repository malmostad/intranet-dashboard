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
    build(:language, name: "fox barx " * 10).should_not be_valid
  end

  it "should validate the uniqueness" do
    create(:language, name: "fox")
    build(:language, name: "fox").should_not be_valid
  end

  it "should be destroyed" do
    language = create(:language)
    expect { language.destroy }.to change(Language, :count).by(-1)
  end

  describe "merged" do
    before(:each) do
      @lang_1 = create(:language)
      @user_1 = create(:user, languages: [@lang_1])
      @lang_2 = create(:language)
      @user_2 = create(:user, languages: [@lang_2])
    end

    it "should destroy the first language" do
      expect { @lang_1.merge(@lang_2) }.to change(Language, :count).by(-1)
    end

    it "should not destroy the second language" do
      @lang_1.merge(@lang_2)
      expect(Language.last).to eq(@lang_2)
    end

    it "should not change a users number of languages (if she doesn't have both)" do
      expect { @lang_1.merge(@lang_2) }.to change(@user_1.languages, :count).by(0)
    end

    it "should change a users number of languages (if she has both)" do
      @user_1.languages << @lang_2
      expect { @lang_1.merge(@lang_2) }.to change(@user_1.languages, :count).by(-1)
    end
  end
end
