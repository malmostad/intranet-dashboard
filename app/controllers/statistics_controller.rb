# -*- coding: utf-8 -*-
class StatisticsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_admin

  def index
    render text: "index"
  end

  def ldap_diff
    render text: "ldap diff"
    # headers['Content-Disposition'] = 'attachment; filename="ldap_diff-' + Time.now().to_i.to_s + '.xls"'
    # headers['Cache-Control'] = ''
    # respond_to do |format|
    #   format.xls { render layout: false, content_type: "application/vnd.ms-excel" }
    # end
  end
end


