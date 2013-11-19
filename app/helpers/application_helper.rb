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

  # Text only form style display of attribute
  def show_attribute(name, value)
    content_tag(:div,
      content_tag(:div, "#{name}:", class: 'control-label') +
      content_tag(:div, value, class: 'controls'),
      class: 'control-group text-only')
  end

  def delete_icon_text
    raw "#{content_tag(:span, nil, class: 'icon-trash icon-large')} Radera"
  end

  def add_icon_text
    raw "#{content_tag(:span, nil, class: 'icon-plus')} Lägg till"
  end

  def show_on_map(address)
    "https://komin.malmo.se/karta?#{{zoomlevel: 4, maptype: "karta", poi: address}.to_query}"
  end
end
