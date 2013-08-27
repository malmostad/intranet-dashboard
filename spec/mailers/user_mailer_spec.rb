require "spec_helper"

describe UserMailer do
  describe "change_room" do
    let(:mail) { UserMailer.change_room }

    it "renders the headers" do
      mail.subject.should eq("Change room")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "change_streetaddress" do
    let(:mail) { UserMailer.change_streetaddress }

    it "renders the headers" do
      mail.subject.should eq("Change streetaddress")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
