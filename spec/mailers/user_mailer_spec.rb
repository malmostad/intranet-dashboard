require "spec_helper"

describe UserMailer do
  describe "change_address" do
    let(:mail) { UserMailer.change_address }

    it "renders the headers" do
      mail.subject.should eq("Change address")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
