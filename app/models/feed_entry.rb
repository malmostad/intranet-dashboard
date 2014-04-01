class FeedEntry < ActiveRecord::Base
  belongs_to :feed

  # Define additional feed entry elements
  [ [ "wfw:commentRss", as: "comment_rss" ],
    [ "slash:comments", as: "count_comments" ],
    [ "enclosure",      as: "image", value: "url" ],
    [ "enclosure",      as: "image_medium", value: "dashboard:url-medium" ],
    [ "enclosure",      as: "image_large", value: "dashboard:url-large" ]
  ].each do |element|
    Feedjira::Feed.add_common_feed_entry_element(element[0], element[1])
  end

  before_save do
    # Don't save urls for non-ssl media if not allowed in config
    if !APP_CONFIG["allow_non_ssl_media"] && image? && image.match(%q(^http://))
      self.image = nil
      self.image_medium = nil
      self.image_large = nil
    end
  end
end
