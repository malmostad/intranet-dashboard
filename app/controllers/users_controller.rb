# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin_or_myself, only: [ :edit, :update ]
  before_filter :require_admin, only: :destroy

  # Search users and return a hash in json or @users for html rendering
  def index
    @limit = 25
    page = params[:page].present? ? params[:page].to_i : 0
    @offset = page * @limit
    @user_stats = user_stats if admin?
    @users = User.search(params, @limit, @offset)

    respond_to do |format|
      format.html {
        # Don't execute a db count
        @has_more = @users.size == @limit
        if request.xhr?
          render :_results, layout: false
        else
          render :index
        end
      }
      format.json {
        render json: @users.map { |u|
          { username: u.username,
            avatar_full_url: u.avatar.url(:mini_quadrat),
            first_name: u.first_name,
            last_name: u.last_name,
            company_short: u.company_short }
        }
      }
    end
  end

  def show
    @user = User.where(username: params[:username]).includes(:subordinates).first
    @user_roles = user_roles
    @roles = Role.order(:name)
    @colleagueship = current_user.colleagueships.where(colleague_id: @user.id).first

    if @user.blank?
      reset_body_classes
      sub_layout
      render template: "404", status: 404

    elsif request.xhr?
      render layout: false
    else
      render layout: true
    end
  end

  def edit
    @user = User.where(id: params[:id]).includes(:roles).first
    @user_roles = user_roles
    @roles = Role.all
    if request.xhr?
      render layout: false
    end
  end

  def update
    @user = User.find(params[:id])
    @roles = Role.all

    # Prevent an admin from un-admin herself
    if admin? && editing_myself? && params[:user][:admin] == "0"
      @user.errors.add(:admin, "Du kan inte ta bort din egen administratörsrättighet!")
    end
    # @user.errors.add(:admin, "Du kan inte ta bort din egen administratörsrättighet!")

    respond_to do |format|
      # Some fields require admin rights for mass assignment
      if @user.errors.empty? && @user.update_attributes(params[:user], as: ( :admin if admin? ))
        set_profile_cookie
        format.html {
          redirect_to user_path(@user.username), notice: "Användaren uppdaterades"
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
    current_user.roles.order(:name).map { |r| r.category == "department" ? 'department': 'working_field' }.compact
  end

  private

  def user_stats
    user_stats = {}
    user_stats["total_users"] = User.count
    user_stats["last_week_users"] = User.where("last_login > ?", Time.now - 1.week).count
    user_stats["registered_last_week_users"] = User.where("created_at > ?", Time.now - 1.week).count
    user_stats["has_status"] = User.where("status_message != ?", "").count
    user_stats["has_avatar"] = User.where("avatar_updated_at != ?", "").count
    user_stats
  end

  # Clear the users key/value ttl cache for feed entries
  def clear_feed_entries_cache(category)
    Rails.cache.delete("feed_entries-#{current_user.id}-#{category}")
  end

  # Clear the users key/value ttl cache for shortcuts
  def clear_shortcut_cache(category)
    Rails.cache.delete("shortcuts-#{current_user.id}-#{category}")
  end
end
