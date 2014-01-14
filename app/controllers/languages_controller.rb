# -*- coding: utf-8 -*-
class LanguagesController < ApplicationController

  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin, except: :suggest

  def index
    @languages = Language.order(:name)
  end

  def new
    @language = Language.new
  end

  def edit
    @language = Language.find(params[:id])
  end

  def create
    @language = Language.new(params[:language])

    if @language.save
      redirect_to languages_url, notice: "Språket skapades"
    else
      render action: "new"
    end
  end

  def update
    @language = Language.find(params[:id])

    if @language.update_attributes(params[:language])
      redirect_to languages_url, notice: "Språket uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @language = Language.find(params[:id])
    @language.destroy
    redirect_to languages_url, notice: "Språket raderades"
  end

  # Returns a json hash with languages
  def suggest
    q = "#{params[:q]}%"
    @languages = Language.where("name like ?", q).order(:name).limit(20)

    # Let user create new languages
    @languages.unshift Language.new(name: params[:q].downcase)

    # We use the :name as :id too for language_list= assignement
    @languages.map! { |l| { id: l.name, name: l.name } }
    render json: @languages
  end

  # Same as `suggest` but we do not allow creation
  def search
    @languages = Language.where("name like ?", "#{params[:into]}%").order(:name).limit(20)
    @languages.map! { |l| { id: l.id, name: l.name } }
    render json: @languages
  end

  def edit_merge
    @language = Language.find(params[:id])
  end

  def merge
    @language = Language.find(params[:id])
    @into = Language.where(name: params[:into]).first

    if @language.merge @into
      redirect_to languages_url, notice: "#{@language.name} har sligits ihop med #{@into.name}"
    else
      render action: "edit_merge"
    end
  end
end
