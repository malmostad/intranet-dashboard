# -*- coding: utf-8 -*-
class StatisticsController < ApplicationController
  before_action { add_body_class('edit') }
  before_action { sub_layout("admin") if admin? }
  before_action :require_admin

  def index
    total = User.count
    @user_stats = Rails.cache.fetch("user_stats", expires_in: 4.hours) do
      {
        total: total,
        last_week_users: User.where("last_login > ?", Time.now - 1.week).count,
        registered_last_week_users: User.where("created_at > ?", Time.now - 1.week).count,
        deactivated: User.unscoped.where(deactivated: true).count,
        has_address: total - User.where(address: [nil, ""]).count,
        has_room: total - User.where(room: [nil, ""]).count,
        title: {
          has: total - User.where(title: [nil, ""]).count,
          distinct: User.uniq.count(:title)
        },
        company: {
          has: total - User.where(company: [nil, ""]).count,
          distinct: User.uniq.count(:company)
        },
        division: {
          has: total - User.where(department: [nil, ""]).count,
          distinct: User.uniq.count(:department)
        },
        adm_department: {
          has: total - User.where(adm_department: [nil, ""]).count,
          distinct: User.uniq.count(:adm_department)
        },
        house_identifier: {
          has: total - User.where(house_identifier: [nil, ""]).count,
          distinct: User.uniq.count(:house_identifier)
        },
        physical_delivery_office_name: {
          has: total - User.where(physical_delivery_office_name: [nil, ""]).count,
          distinct: User.uniq.count(:physical_delivery_office_name)
        },
        status: {
          has: User.where.not(status_message: [nil, ""]).count,
          distinct: User.uniq.count(:status_message)
        },
        has_professional_bio: total - User.where(professional_bio: [nil, ""]).count,
        has_cmg_id: total - User.where(cmg_id: 0).count,
        has_avatar: User.where("avatar_updated_at != ?", "").count,
        changed_shortcuts: User.where(changed_shortcuts: true).count,
        ldap_diff_mtime: File.exists?(APP_CONFIG["ldap"]["diff_log"]) ? File.mtime(APP_CONFIG["ldap"]["diff_log"]).localtime.to_s[0..18] : false,
        total_users: total
      }
    end
  end

  def ldap_diff
    send_file APP_CONFIG["ldap"]["diff_log"], type: :xlsx, disposition: "attachment", filename: "ldap_diff.xlsx"
  end
end
