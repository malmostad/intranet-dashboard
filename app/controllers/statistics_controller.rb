# -*- coding: utf-8 -*-
class StatisticsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_admin

  def index
    @user_stats = {}
    total = User.count
    @user_stats["last_week_users"] = User.where("last_login > ?", Time.now - 1.week).count
    @user_stats["registered_last_week_users"] = User.where("created_at > ?", Time.now - 1.week).count
    @user_stats["deactivated"] = User.unscoped.where(deactivated: true).count
    @user_stats["has_address"] = total - User.where(address: [nil, ""]).count
    @user_stats["has_room"] = total - User.where(room: [nil, ""]).count
    @user_stats["has_title"] = total - User.where(title: [nil, ""]).count
    @user_stats["has_company"] = total - User.where(company: [nil, ""]).count
    @user_stats["has_department"] = total - User.where(department: [nil, ""]).count
    @user_stats["has_status"] = total - User.where(status_message: [nil, ""]).count
    @user_stats["has_professional_bio"] = total - User.where(professional_bio: [nil, ""]).count
    @user_stats["has_cmg_id"] = total - User.where(cmg_id: 0).count
    @user_stats["has_avatar"] = User.where("avatar_updated_at != ?", "").count
    @user_stats["ldap_diff_mtime"] = File.exists?(APP_CONFIG["ldap"]["diff_log"]) ? File.mtime(APP_CONFIG["ldap"]["diff_log"]).localtime.to_s[0..18] : false
    @user_stats["total_users"] = total
    @user_stats
  end

  def ldap_diff
    send_file APP_CONFIG["ldap"]["diff_log"], type: :xlsx, disposition: "attachment", filename: "ldap_diff.xlsx"
  end
end
