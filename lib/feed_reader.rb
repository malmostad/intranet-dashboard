# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

# TODO: Add support for Atom and normaLize formats

class FeedReader
  # Suppots only RSS 2.0 at the moment
  def initialize( args = {} )
    @options = {
    }.merge(args)
  end

  # Return a Hash with feed data or an error message
  def consume(name, url)
    @name = name
    @url = url

    doc = fetch
    return  doc if doc.kind_of? Hash

    ngdoc = Nokogiri::XML( doc )
    return error_msg( ngdoc.errors, 'Det gick inte att tolka RSS-flödet: ' ) unless valid?( ngdoc )
    return error_msg( 'Not a valid RSS 2.0 feed', 'Detta verkar inte vara ett RSS 2.0-flöde: ' ) unless rss_20?( ngdoc )

    data = Hash.new
    data['title'] = name
    data['items'] = Array.new
    data['has_image'] = false

    ngdoc.xpath("//item").each do |item|

      # Check of we have an image in one or another form
      image = item.xpath('enclosure/@url').text
      image = (ngdoc.namespaces["xmlns:media"] && item.xpath("media:content[@medium='image']/@url").text) || image
      data['has_image'] = true unless image.empty?

      data['items'] << {
        'title'       => item.xpath("title").text,
        'link'        => item.xpath("link").text,
        'published'   => item.xpath('pubDate').text.length > 0 ? item.xpath('pubDate').text : item.xpath('dc:date').text,
        'description' => item.xpath('description').text,
        'content'     => (ngdoc.namespaces["xmlns:content"] && item.xpath("content:encoded").inner_html) || false,
        'image'       => image
      }
    end
    data
  end

  private

  # Fetch remote feed
  def fetch
    doc = String.new
    # TODO:  there are some problems with both :read_timeout and Timeout::timeout
    # for some "Server not found" domains like http://www.xgoogle.com/ where the default "open" timeout is executed
    begin
      open( @url, :read_timeout => @options[:timeout] ).each do |line|
        doc << line
      end
    rescue StandardError
      return error_msg( $!, 'Ett fel inträffade när RSS-flödet skulle hämtas: ' )
    end
    doc
  end

  # Is it valid XML?
  def valid?( ngdoc )
    return ngdoc.errors.empty? ? true : false
  end

  # Is it an RSS 2.0 feed?
  def rss_20?( ngdoc )
    return ngdoc.xpath("/rss/@version='2.0'") ? true : false
  end

  # Logg and return error message
  def error_msg( error, message )
    Rails.logger.error "#{error} #{@url}"
    return {
      'error' => error,
      'human_message' => message,
      'title' => @name,
      'url' => @url
    }
  end
end
