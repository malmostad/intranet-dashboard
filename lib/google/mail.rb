module Google
  class Mail
    # Mandatory args:
    # :consumer_secret => 'secret', :consumer_key => 'key', :username => 'username'
    def initialize( args = {} )
      @options = {
      }.merge(args)
    end

    def read_box( args= {})
      @box_options = {
        :box =>'INBOX',
        :items => 10
      }.merge(args)

      email_address = "#{@options[:username]}@#{@options[:consumer_key]}"
      imap = connect
      imap.examine(@box_options[:box])

      status = imap.status( @box_options[:box], ["MESSAGES", "UNSEEN"] )
      summary = {
        "total" => status["MESSAGES"],
        "unseen" => status["UNSEEN"]
      }

      messages = []
      if summary['total'] > 0
        # Get inbox messages and check which messages that are unread
        imap.fetch(1..@box_options[:items], ["ENVELOPE", "FLAGS","X-GM-THRID"] ).each do |message|
          envelope = message.attr["ENVELOPE"]
          flags = message.attr["FLAGS"]
          gmail_uid = message.attr["X-GM-THRID"].to_s(16)

          message = {
            "gmail_uid" => gmail_uid,
            "read" => flags.include?(:Seen),
            "date" => envelope.date,
            "from_name" => Google::Helpers.mime_decode(envelope.from[0].name),
            "from_address" => "#{envelope.from[0].mailbox}@#{envelope.from[0].host}",
            "subject" => Google::Helpers.mime_decode(envelope.subject)
          }
          messages << message
        end
      end

      disconnect(imap)

      { "mailbox" => @box_options[:box], "summary"  => summary, "messages" => messages }
    end

    private

    # Connect to imap with Gmail's 2-legged ouath
    def connect
      connection = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
      connection.authenticate('XOAUTH', @options)
      connection
    end

    def disconnect(connection)
      connection.logout
      connection.disconnect
    end
  end
end
