class FeedEntry < ActiveRecord::Base
  belongs_to :feed

  # Define additional feed entry elements
  [ [ "wfw:commentRss", as: "comment_rss" ],
    [ "slash:comments", as: "count_comments" ],
    [ "enclosure",      as: "image_medium", value: "dashboard:url-medium" ],
    [ "enclosure",      as: "image_large", value: "dashboard:url-large" ]
  ].each do |element|
    Feedzirra::Feed.add_common_feed_entry_element(element[0], element[1])
  end
end
