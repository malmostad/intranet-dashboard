# -*- coding: utf-8 -*-
class AvatarsController < ApplicationController

  before_action { add_body_class('employee') }
  before_action :require_user, except: "show"
  before_action :require_admin_or_myself, except: "show"

  # Stream the :usernames's profile picture, or use the fallback avatar.png
  def show
    @user = User.where(username: params[:username]).first
    if @user.blank?
      render text: '404 Not found', status: 404
    else
      style = params[:style].present? ? params[:style] : @user.avatar.default_style.to_s
      begin
        # Send etag based on the age of the image and the style
        fresh_when etag: @user.avatar_updated_at.to_s + style
        send_file @user.avatar.path(style) || File.join(Rails.root, 'app/assets/images/avatar.jpg'),
          type: @user.avatar_content_type || "image/jpg",
          disposition: 'inline'
      rescue
        render text: '404 Not found', status: 404
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    # We need to know where we should send the user after update
    session[:referer] = request.env["HTTP_REFERER"] || nil
  end

  def update
    @user = User.find(params[:id])
    # Some User fields require admin rights for mass assignment
    if @user.update_attributes(params[:user], as: ( :admin if admin? ))
      redirect_to session[:referer] || user_path(@user.username), notice: "Profilbilden uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.avatar = nil
    @user.save
    redirect_to user_path(@user.username), notice: "Profilbilden raderades"
  end
end
