# -*- coding: utf-8 -*-
class StatisticsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_admin

  def index
  end

  def ldap_diff
    send_file File.join(Rails.root, "data", "ldap_diff.xls"), type: :xls, disposition: "attachment", filename: "ldap_diff.xls"
  end
end
