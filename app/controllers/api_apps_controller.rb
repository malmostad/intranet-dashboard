# -*- coding: utf-8 -*-

class ApiAppsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") }
  before_filter :require_admin

  def index
    @api_apps = ApiApp.all
  end

  def show
    @api_app = ApiApp.find(params[:id])
    if session[:app_secret].present?
      @api_app.app_secret = session[:app_secret]
      session.delete :app_secret
    end
  end

  def new
    @api_app = ApiApp.new
  end

  def edit
    @api_app = ApiApp.find(params[:id])
  end

  def create
    @api_app = ApiApp.new(params[:api_app])

    if @api_app.save
      session[:app_secret] = @api_app.app_secret
      redirect_to @api_app, notice: "Api-applikationen registrerades."
    else
      render action: "new"
    end
  end

  def update
    @api_app = ApiApp.find(params[:id])

    if @api_app.update_attributes(params[:api_app])
      redirect_to @api_app, notice: 'Api-applikationen uppdaterades.'
    else
      render action: "edit"
    end
  end

  def destroy
    @api_app = ApiApp.find(params[:id])
    @api_app.destroy
    redirect_to api_apps_url
  end

  def create_app_secret
    @api_app = ApiApp.find(params[:id])
    @api_app.generate_app_secret
    @api_app.save
    render :create_app_secret, layout: false
  end
end
