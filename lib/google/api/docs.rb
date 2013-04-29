# -*- coding: utf-8 -*-

module Google
  class Docs < API

    def list
      params = {
        'xoauth_requestor_id' => @options[:xoauth_requestor_id],
        'max-results' => '10'
      }

      feed = @client.get("https://docs.google.com/feeds/#{@options[:xoauth_requestor_id]}/private/full", params )
      throw :halt, [500, "Unable to query docs feed"] if feed.nil?

      ngdoc = Nokogiri::XML( feed.body )
      # Extract some data. Add more if needed
      data = Hash.new
      data['entries'] = Array.new

      entries = ngdoc.xpath("//xmlns:entry")
      data['summary'] = { "total" => entries.length }
      entries.each do |item|
        data['entries'] << {
          'title' => item.xpath("xmlns:title").text,
          'author' => item.xpath("xmlns:author/xmlns:name").text,
          'link'  => item.xpath("xmlns:link[@rel='alternate']/@href").text,
          'updated'  => item.xpath('xmlns:updated').text
        }
      end
      data
    end
  end
end
