# # -*- coding: utf-8 -*-
require 'open-uri'

# XPath selectors are efficient, CSS selectors are readable
module SiteSearch
  class Search
    attr_reader :error

    def initialize(query, options={})
      @query = query
      @base_search_url = "#{APP_CONFIG['site_search_query_url']}?oenc=UTF-8&"
      @options = { read_timeout: 1 }.merge(options)
      search
    end

    # Send a GET request to the Siteseeker server and create a Nokogiri doc from the returned HTML
    def search
      begin
        # Siteseeker is slow and indexing is only done at night so we cache hard
        html = Rails.cache.fetch(Digest::SHA1.hexdigest("search-#{@query}"), expires_in: 6.hours) do
          open("#{@base_search_url}#{@query}", read_timeout: @options[:read_timeout]).read
        end
        document = Nokogiri::HTML(html, nil, "UTF-8")
        @results = clean_up(document).xpath("/html/body")
      rescue Exception => e
        Rails.logger.error "Siteseeker: #{e}"
        @error = e
        @results = Nokogiri::HTML("<error>#{e}</error>")
      end
    end

    def sorting
      @results.css('div.ess-sortlinks').xpath("a | span[@class='ess-current']").map do |sort_by|
        next if sort_by.text.downcase.strip == "kategori"
        OpenStruct.new(
          text: sort_by.text.strip,
          query: URI::parse(sort_by.xpath("@href").text).query,
          current: sort_by.xpath("@href").empty?
        )
      end.compact
    end

    def total
      @results.css('#essi-hitcount').text.to_i
    end

    def more_query
      URI::parse(@results.xpath("//*[@class='ess-respages']/*[@class='ess-next']/@href").text).query
    end

    def editors_choice
      @results.xpath("//*[@class='ess-bestbets']").map do |ec|
        OpenStruct.new(
          text: ec.xpath("dt/a").text,
          url: ec.xpath("dt/a/@href").text,
          summary: ec.xpath("dd").text
        )
      end
    end

    def suggestions
      @results.css(".ess-spelling a").map do |suggestion|
        OpenStruct.new(text: suggestion.text, url: rewrite_query(suggestion.xpath("@href").text))
      end
    end

    def entries
      @results.css("dl.ess-hits dt").map do |entry|
        next unless entry.css('a').present?
        Entry.new(entry)
      end.compact
    end

    def category_groups
      @results.css("[id^=essi-bd-cg-]").map do |category_group|
        OpenStruct.new(
          title: category_group.css(".ess-cat-bd-heading").text.strip.gsub(/:$/, ""),
          categories: category_group.css(".ess-cat-bd-category").map { |entry| Category.new(entry) }
        )
      end
    end

    def category_all
      all = @results.css("p.ess-cat-bd-all")
      OpenStruct.new(
        title: all.css("strong").text,
        query: rewrite_query(all.xpath("strong/a/@href").text),
        hits: all.css(".ess-num").text.strip,
        current?: !!all.xpath("@class").text.match("ess-current")
      )
    end

  protected

    def rewrite_query(url)
      URI::parse(url).query
    end

    # Depollute some Siteseeker crap
    def clean_up(doc)
      doc.css(".ess-separator").remove
      doc.css("@title").remove
      doc.css("@onclick").remove
      doc.css("@tabindex").remove
      doc.css(".ess-label-hits").remove
      doc.css(".ess-clear").remove
      doc
    end
  end

  class Entry
    def initialize(entry)
      @entry = entry
    end

    def number
      @entry.css('.ess-hitnum').text.to_i
    end

    def title
      @entry.css('a').first.text
    end

    def summary
      @entry.xpath("following-sibling::*[1]/div[@class='ess-hit-extract']").text.strip
    end

    def url
      @entry.css('a').first['href']
    end

    def content_type
      @entry.css('.ess-dtypelabel').text.gsub(/[\[\]]/, "").strip
    end

    def date
      @entry.xpath("following-sibling::dd[2]").css('.ess-date').text.strip
    end

    def breadcrumbs
      @entry.xpath("following-sibling::dd[1]/div[@class='ess-special']/ul/li[a]").map do |item|
        OpenStruct.new(text: item.css("a").text.strip, url: item.css("a/@href").text)
      end
    end

    def category
      @entry.xpath("following-sibling::*[2]").css('.ess-category').text.strip
    end
  end

  class Category
    def initialize(category)
      @category = category
    end

    def title
      @category.css("a").text.strip
    end

    def query
      URI::parse(@category.css("a").first['href']).query.strip
    end

    def hits
      @category.css(".ess-num").text.strip
    end

    def current?
      !!@category.xpath("@class").text.match("ess-current")
    end
  end
end
