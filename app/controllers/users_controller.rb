# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin_or_myself, only: [ :edit, :update ]
  before_filter :require_admin, only: :destroy

  def index
    @total_users = User.count
    @last_week_users = User.where("latest_login > ?", Time.now - 1.week).count
    @registered_last_week_users = User.where("created_at > ?", Time.now - 1.week).count
    @has_status = User.where("status_message != ?", "").count
  end

  # Search user on the fields username, email, first_name, last_name
  # Returns a hash in json or a @users array for html rendering
  def search
    term = "%#{params[:term]}%"
    if term.present?
      @users = User.search(term, 50)
    else
      @users = {}
    end

    respond_to do |format|
      format.html
      format.json {
        render json: @users.map { |u|
          email = (u.email.present? ? u.email : "ingen e-postaddress").downcase
          { id: u.id, username: u.username, email: email, avatar_full_url: "#{avatar_full_url(u.username, :mini_quadrat)}", first_name: u.first_name, last_name: u.last_name }
        }
      }
    end
  end

  def show
    @user = User.where(username: params[:username]).first
    if @user.blank?
      reset_body_classes
      sub_layout
      render template: "404", status: 404
    end
  end

  def edit
    @user = User.where(id: params[:id]).includes(:roles).first
    @user_roles = user_roles
    @roles = Role.all
  end

  def update
    @user = User.find(params[:id])
    @roles = Role.all
    # Prevent and admin from un-admin herself
    if admin? && editing_myself? && params[:user][:is_admin] == "0"
      flash.now[:warning] = "Du kan inte ta bort din egen administratörsrättighet!"
      render action: "edit"
    else
      # Pass empty role HBTM array if all roles are unchecked
      params[:user] = { role_ids: [] } if params[:user][:role_ids].blank?
      # some fields require admin rights for mass assignment
      if @user.update_attributes(params[:user], as: ( :admin if admin? ))
        set_profile_cookie
        redirect_to user_path(@user.username), notice: "Användaren uppdaterades"
      else
        render action: "edit"
      end
    end
  end

  def update_status_message
    respond_to do |format|
      current_user.status_message = params[:status_message]
      current_user.status_message_updated_at = Time.now
      if current_user.save
        format.html { redirect_to root_path }
        format.json { render json: { response: "ok", status_message: User.find(current_user.id).status_message }, status: 200 }
      else
        format.html { redirect_to root_path; flash[:warning] = "Din status kunde inte uppdateras. Försök lite senare." }
        format.json { render json: { response: "error", status_message: current_user.status_message }, status: 500 }
      end
    end
  end

  def my_profile
    redirect_to user_path(current_user.username)
  end

  def my_roles
    redirect_to edit_user_path(current_user.id)
  end

  # User selects optional feeds
  def select_feeds
    @user = User.where(id: current_user.id).includes(:roles, :feeds).first
    @feeds = Feed.where(category: params[:category]).includes(:roles)
  end

  def update_feeds
    # Get users feed ids for **all other** feed categories so we don't delete them
    other_categories_feeds = current_user.feeds.where("category != ?", params[:category]).pluck(:id)

    # Set **all** the users feeds
    current_user.feed_ids = other_categories_feeds + ( params[:user][:feed_ids] or [] )

    clear_feed_entries_cache(params[:category])
    redirect_to root_path, notice: "Dina flöden uppdaterades"
  end

  # Reset user feeds to default for one params[:category]
  def reset_feeds
    # Get users feed ids for **all other** feed categories so we don't delete them
    current_user.feed_ids = current_user.feeds.where("category != ?", params[:category]).pluck(:id)

    clear_feed_entries_cache(params[:category])
    redirect_to root_path, notice: "Inställningarna för #{Feed::CATEGORIES[params[:category]]} återställdes"
  end

  # User selects optional shortcuts
  def select_shortcuts
    @user = User.where(id: current_user.id).includes(:roles, :shortcuts).first
    @shortcuts = Shortcut.where(category: params[:category]).includes(:roles)
  end

  def update_shortcuts
    # Get users shortcuts ids for **all other** shortcut categories so we don't delete them
    other_categories_shortcuts = current_user.shortcuts.where("category != ?", params[:category]).pluck(:id)

    # Set **all** the users shortcuts
    current_user.shortcut_ids = other_categories_shortcuts + ( params[:user][:shortcut_ids] or [] )

    clear_shortcut_cache(params[:category])
    redirect_to root_url, notice: "Dina #{Shortcut::CATEGORIES[params[:category]]} uppdaterades"
  end

  # Reset user shortcuts to default for one params[:category]
  def reset_shortcuts
    # Get users shortcuts ids for **all other** shortcut categories so we don't delete them
    current_user.shortcut_ids = current_user.shortcuts.where("category != ?", params[:category]).pluck(:id)

    clear_shortcut_cache(params[:category])
    redirect_to root_url, notice: "Inställningarna för #{Shortcut::CATEGORIES[params[:category]]} återställdes"
  end

  def add_colleague
    @user = User.where(username: params[:add_colleague]).first
    render :layout => false
  end

  def user_roles
    current_user.roles.map { |r| r.category == "department" ? 'department': 'working_field' }.compact
  end

  private

  # Clear the users key/value ttl cache for feed entries
  def clear_feed_entries_cache(category)
    Rails.cache.delete("feed_entries-#{current_user.id}-#{category}")
  end

  # Clear the users key/value ttl cache for shortcuts
  def clear_shortcut_cache(category)
    Rails.cache.delete("shortcuts-#{current_user.id}-#{category}")
  end
end
