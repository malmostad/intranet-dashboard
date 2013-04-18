# -*- coding: utf-8 -*-
module ApplicationHelper

  def title(t)
    @title = t
  end

  def title_suffix
    APP_CONFIG["title_suffix"]
  end

  def h1
    @title
  end

  def separator(current, total, question=false)
    separator = ", " if total > current + 2
    separator = " eller " if total == current + 2
    separator = "?" if total == current + 1 && question
    separator
  end

  def page_title
    !@title.nil? ? "#{@title} - #{title_suffix}" : title_suffix
  end

  def tags_whitelist
    { tags: %w(a i em li ul ol h1 h2 h3 blockquote br sub sup p img),
      attributes: %w(href src) }
  end
end
