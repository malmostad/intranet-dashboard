# -*- coding: utf-8 -*-
class StatisticsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_admin

  def index
    @user_stats = {}
    @user_stats["total_users"] = User.count
    @user_stats["last_week_users"] = User.where("last_login > ?", Time.now - 1.week).count
    @user_stats["registered_last_week_users"] = User.where("created_at > ?", Time.now - 1.week).count
    @user_stats["has_address"] = @user_stats["total_users"] - User.where(address: [nil, ""]).count
    @user_stats["has_status"] = User.where("status_message != ?", "").count
    @user_stats["has_avatar"] = User.where("avatar_updated_at != ?", "").count
    @user_stats
  end

  def ldap_diff
    send_file File.join(Rails.root, "data", "ldap_diff.xls"), type: :xls, disposition: "attachment", filename: "ldap_diff.xls"
  end
end
