# -*- coding: utf-8 -*-
require "spec_helper"

describe UserMailer do
  describe "change_address" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.change_address(user) }

    it "renders the headers" do
      mail.subject.should eq("Adressändring")
      mail.to.first.should match(APP_CONFIG["switchboard_email"])
      mail.from.first.should match(user.email)
    end

    it "renders the body" do
      mail.body.encoded.should match("Hej televäxeln")
    end
  end

end
