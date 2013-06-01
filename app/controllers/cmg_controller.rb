# -*- coding: utf-8 -*-
class CmgController < ApplicationController
  def index
    respond_to do |format|
      format.xml
    end
  end
end
