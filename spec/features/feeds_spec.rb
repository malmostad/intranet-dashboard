# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Feeds' do
  before(:all) do
    @user = create(:user)
    create_feeds_for_user(@user)
  end

  before(:each) do
    login(@user.username, '') # Stubbed auth
  end

  it 'should have news feed entries box' do
    expect(page).to have_selector('h1', text: 'Nyheter')
  end

  it 'should have news feed entries' do
    expect(all('.column-2 section.feeds .box-content li').count).to be > 1
  end

  it 'should lazy load more combined news feed entries', js: true do
    before = all('.column-2 section.feeds .box-content li').count
    expect(find('.box-content li.load-more button').text).to include 'Visa fler'
    page.execute_script('window.scrollTo(0, 10000)')
    sleep 0.2
    # find('.box-content li.load-more button').click
    save_and_open_page
    expect(find('.box-content li.load-more button').text).to include 'Visa fler'
    expect(before).to be < all('.column-2 section.feeds .box-content li').count
  end

  it 'administration should require and administrator' do
    visit feeds_path
    expect(page).to have_selector('.error', text: 'Du saknar behörighet')
  end

  describe 'administration' do
    before(:all) do
      @user.update_attribute(:admin, true)
    end

    before(:each) do
      login(@user.username, '') # Stubbed auth
      visit feeds_path
    end

    it 'should be available for administrators' do
      expect(page).to have_selector('h1', text: 'Nyhetsflöden')
    end

    it 'should create feed' do
      click_link('Lägg till')
      fill_in 'feed_feed_url', with: 'https://github.com/jnicklas/capybara/commits/master.atom'
      click_button 'Spara'
      expect(page).to have_selector('.flash.notice', text: 'skapades')
    end

    it 'should update feed' do
      first('table tbody td a').click
      fill_in 'feed_feed_url', with: 'https://github.com/ariya/phantomjs/commits/master.atom'
      click_button 'Spara'
      expect(page).to have_selector('.flash.notice', text: 'uppdaterades')
    end

    it 'should delete feed', js: true do
      first('a.btn-danger').click
      page.evaluate_script('window.confirm()')
      expect(page).to have_selector('.flash.notice', text: 'raderades')
    end

    it 'should refresh feed', js: true do
      first('table tbody td a').click
      click_on 'Radera alla nyheter i flödet'
      page.evaluate_script('window.confirm()')
      expect(page).to have_selector('.flash.notice', text: 'De senaste nyheterna hämtades från källan')
    end
  end
end
