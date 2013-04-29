# -*- coding: utf-8 -*-
module ApplicationHelper

  def title(t)
    @title = t
  end

  def title_suffix
    APP_CONFIG[:title_suffix]
  end

  def h1
    @title
  end

  def page_title
    !@title.nil? ? "#{@title} - #{title_suffix}" : title_suffix
  end

  def canonical_url
    request.protocol + request.env["HTTP_HOST"] + root_path
  end

  def tags_whitelist
    { 
      :tags => %w(a i em li ul ol h1 h2 h3 blockquote br sub sup p img), 
      :attributes => %w(href src)
    }
  end
end
