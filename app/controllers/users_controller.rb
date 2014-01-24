# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter { add_body_class('employee') }
  before_filter :require_user
  before_filter :require_admin_or_myself, only: [ :edit, :update ]
  before_filter :require_admin, only: :destroy

  # Search users and return a hash in json or @users for html rendering
  def index
    @limit = 25
    page = params[:page].present? ? params[:page].to_i : 0
    @offset = page * @limit
    results = User.search(params.except(:controller, :action), @limit, @offset)
    @users = results[:users]
    @total = results[:total]
    @has_more = @total.present? ? (@offset + @limit < @total) : false

    if request.xhr?
      render :_results, layout: false
    else
      render :index
    end
  end

  def suggest
    @users = User.search(params.except(:controller, :action), 25)[:users]

    render json: @users.map { |u|
      { username: u.username,
        avatar_full_url: u.avatar.url(:mini_quadrat),
        path: "#{root_path}users/#{u.username}",
        first_name: u.first_name,
        last_name: u.last_name,
        company_short: u.company_short || "",
        department: u.department || "" }
    }
  end

  def show
    @user = User.where(username: params[:username]).includes(:subordinates).first

    if @user.present?
      @colleagueship = current_user.colleagueships.where(colleague_id: @user.id).first
      if request.xhr?
        render layout: false
      else
        render layout: true
      end
    else
      not_found
    end
  end

  def edit
    @user = User.where(id: params[:id]).includes(:roles).first
    if @user.present?
      @user_roles = user_roles
      @roles = Role.order(:name)
      if request.xhr?
        render layout: false
      end
    else
      not_found
    end
  end

  def update
    @user = User.find(params[:id])
    @roles = Role.all
    notify_switchboard = (params[:user][:address].present? && params[:user][:address] != @user.address) ||
      (params[:user][:room].present? && params[:user][:room] != @user.room)

    # Prevent an admin from un-admin herself
    if admin? && editing_myself? && params[:user][:admin] == "0"
      @user.errors.add(:admin, "Du kan inte ta bort din egen administratörsrättighet!")
    end

    # Some fields require admin rights for mass assignment
    if @user.errors.empty? && @user.update_attributes(params[:user], as: ( :admin if admin? ))
      set_profile_cookie

      # Send mail to switchboard if address is changed
      if notify_switchboard
        UserMailer.delay.switchboard_changes(@user, params[:user])
      end
      redirect_to user_path(@user.username), notice: "Katalogkortet uppdaterades"
    else
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "Användaren raderades"
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

  def activities
    @activities = AastraCWI.activities(params[:cmg_id])
    render "activities", layout: false
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
    @user.roles.order(:name).map { |r| r.category == "department" ? 'department': 'working_field' }.compact
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
