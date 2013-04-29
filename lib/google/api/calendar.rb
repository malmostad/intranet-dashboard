# -*- coding: utf-8 -*-

module Google
  class Calendar < API

    def list
      params = {
        'xoauth_requestor_id' => @options[:xoauth_requestor_id],
        'orderby' => 'starttime',
        'max-results' => '10',
        'singleevents' => 'true',
        'sortorder' => 'a',
        'start-min' => Time.now.strftime('%Y-%m-%dT%H:%M:%S')
      }

      # feed = @client.get('https://www.googleapis.com/calendar/v3/calendars/primary/events', params ) # Can't get v3 to work with 2-legged oauth
      feed = @client.get('https://www.google.com/calendar/feeds/default/private/full', params )
      throw :halt, [500, "Unable to query calendar feed"] if feed.nil?

      ngdoc = Nokogiri::XML( feed.body )
      # Extract some data. Add more if needed
      data = Hash.new
      data['entries'] = Array.new
      entries = ngdoc.xpath("/xmlns:feed/xmlns:entry")
      data['summary'] = { "total" => entries.length }

      entries.each do |item|
        data['entries'] << {
          'title' => item.xpath("xmlns:title").text,
          'organizer' => item.xpath("gd:who[@rel='http://schemas.google.com/g/2005#event.organizer']/@valueString").text,
          'location' => item.xpath("gd:where/@valueString").text,
          'link'  => item.xpath("xmlns:link[@rel='alternate']/@href").text,
          'start'  => item.xpath('gd:when[@startTime][@endTime]/@startTime').text,
          'end'  => item.xpath('gd:when[@startTime][@endTime]/@endTime').text
        }
      end
      data
    end
  end
end
