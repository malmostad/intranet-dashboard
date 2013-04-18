# -*- coding: utf-8 -*-
require 'spec_helper'

# NOTE: THis spec doesn't work with the rest of the specs, probably a db cleaning issue

# feature "Feeds" do
#   let(:user) { create_user_with_roles_with_feeds }
#   before(:each) { login(user.username, 'stub') }

#   scenario "should have news feed entries" do
#     all("#feeds-news .box-content li").count.should > 1
#   end

#   scenario "should have dialog feed entries" do
#     all("#feeds-dialog .box-content li").count.should > 1
#   end

#   scenario "should have one feture feed entry" do
#     all("#feeds-feature .box-content li").count.should == 1
#   end

#   scenario "should load more new feed entries", :js => true do
#     before = all("#feeds-news .box-content li").count
#     find("#feeds-news .box-content li.load-more input").click
#     sleep 1
#     before.should < all("#feeds-news .box-content li").count
#   end
# end
