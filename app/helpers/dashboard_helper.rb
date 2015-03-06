# -*- coding: utf-8 -*-
module DashboardHelper
  def summary(text)
    truncate(strip_tags(HTMLEntities.new.decode text), separator: ' ', length: 140, omission: ' …')
  end

  def feed_tag(text)
    # Special text cutting for internal feeds
    text = 'Blogg' if text.match(/^\s*Blogg\s+[»>]\s+/)
    text = 'Forum' if text.match(/^\s*Forum\s+[»>]\s+/)
    text.sub(/^\s*Nyheter\s+[»>]\s+/, '')
  end

  def show_tag(entry)
    entry.url.match('malmo.se')
  end

  # Is the feed entry a tweet?
  def tweet?(entry)
    entry.guid.present? && !!entry.guid.match('^http://twitter.com/')
  end

  # Add "s" to the end of a name if not already there. Swedish, no apostrophe.
  def possessive(owner)
    owner.match(/[sz]$/) ? owner : "#{owner}s" unless owner.blank?
  end

  def toggle_feed_stream_text
    current_user.combined_feed_stream ? 'Visas sammanslaget' : 'Visas kategoriserat'
  end
end
