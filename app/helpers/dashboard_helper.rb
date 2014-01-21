# -*- coding: utf-8 -*-
module DashboardHelper
  def summary(text)
    sanitize truncate( strip_tags(text), { separator: ' ', length: 140, omission: ' …' } )
  end

  # Is the feed entry a tweet?
  def tweet?(entry)
    entry.guid.present? && !!entry.guid.match('^http://twitter.com/')
  end

  # Add "s" to the end of a name if not already there. Swedish, no apostrophe.
  def possessive(owner)
    owner.match(/[sz]$/) ? owner : "#{owner}s" unless owner.blank?
  end
end
