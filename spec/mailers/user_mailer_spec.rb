# -*- coding: utf-8 -*-
require "spec_helper"

describe UserMailer do
  describe "switchboard_changes" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.switchboard_changes(user, {}) }

    it "renders the headers" do
      expect(mail.subject).to eq("Adressändring")
      expect(mail.to.first).to match(APP_CONFIG["switchboard_email"])
      expect(mail.from.first).to match(user.email)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hej televäxeln")
    end
  end
end
