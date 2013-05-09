# -*- coding: utf-8 -*-
class LanguagesController < ApplicationController

  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_admin, except: :search

  def index
    @languages = Language.all
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
    redirect_to languages_url, notice: "Språket togs bort"
  end


  # Returns a hash in json or a @users array for html rendering
  def search
    q = "%#{params[:q]}%"
    if q.present?
      @languages = Language.where("name like ?", q).order(:name).limit(20)
    else
      @languages = {}
    end
    @languages.map! { |l| {"id" => l.id, "text" => l.name} }
    # Let user create new languages
    @languages.unshift({ "id" => nil, "text" => params[:q] })
    render json: @languages
  end
end
