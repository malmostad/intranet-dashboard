# -*- coding: utf-8 -*-
require 'open-uri'

class SiteSeeker
  def search(query, search_base)
    @query = query.to_query
    @search_base = search_base
    parse(clean_up(fetch_results))
  end

  # Send a GET request to the Siteseeker server and create a Nokogiri doc from the returned HTML
  def fetch_results
    begin
      html = open("#{APP_CONFIG['site_search_query_url']}/?#{@query}&oenc=utf-8", :read_timeout => 10)
      doc = Nokogiri::HTML( html, nil, "UTF-8" )
    rescue Exception => e
      Rails.logger.error "Siteseeker: #{e}"
      doc = Nokogiri::HTML("<error>#{e}</error>")
    end
  end

private
  # Select the data we need and but in a ruby object
  def parse(results)
    if results.css('error').present?
      { error: results.css('error').text }
    else
      {
        sorting: extract_links(results.css(".ess-sortlinks").xpath("a | span/strong")),
        count: results.css('#essi-hitcount').text,
        summary: results.xpath("//h2[@class='ess-topcell']").text.gsub(/Resultat:/, ""),
        entries: results.css("dl.ess-hits dt").map do |entry|
          {
            number: entry.css('.ess-hitnum').text.to_i,
            title: entry.css('a[class^=ess-dtype]'),
            extract: entry.xpath("following-sibling::*[1]/div[@class='ess-hit-extract']").text,
            breadcrumb: entry.xpath("following-sibling::*[1]/div[@class='ess-special']/ul/li"),
            category: entry.xpath("following-sibling::*[2]").css('.ess-category').text,
            date: entry.xpath("following-sibling::*[2]").css('.ess-date').text,
            content_type: entry.css('.ess-dtypelabel').text.gsub(/[\[\]]/, ""),
            file_size: entry.css('.ess-size').text.gsub(/- /, "")
          }
        end,
        paging:  extract_links(results.xpath("//*[@class='ess-respages']/*[@class='ess-page' or @class='ess-current']")),
        more_query: URI::parse(results.css(".ess-respages .ess-next").xpath("@href").text).query,
        categories_sum: results.css(".ess-cat-bd .ess-cat-bd-all"),
        categories: url_rewrite(results.css(".ess-cat-bd [class^=ess-cat-bd]")),
        editors_choice: results.css(".ess-bestbets"),
        suggestions: extract_links(results.xpath("//*[@class='ess-spelling']/ul/li/a"))
      }
    end
  end

  def extract_links(node_set)
    node_set.map do |entry|
      { query: URI::parse(entry.xpath("@href").text).query, text: entry.text }
    end
  end

  # Rewrite href's in each a element based on the @search_base
  def url_rewrite(node_set)
    node_set.map do |entry|
      entry.css("a").each do |a|
        a.set_attribute("href", "#{@search_base}?#{URI::parse(a.xpath("@href").text).query}")
      end
      entry
    end
    node_set
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
