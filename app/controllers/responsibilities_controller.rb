# -*- coding: utf-8 -*-
class ResponsibilitiesController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin, except: [:search, :suggest]

  def index
    @responsibilities = Responsibility.order(:name)
  end

  def new
    @responsibility = Responsibility.new
  end

  def edit
    @responsibility = Responsibility.find(params[:id])
  end

  def create
    @responsibility = Responsibility.new(params[:responsibility])

    if @responsibility.save
      redirect_to responsibilities_url, notice: "Kunskapsområdet skapades"
    else
      render action: "new"
    end
  end

  def update
    @responsibility = Responsibility.find(params[:id])

    if @responsibility.update_attributes(params[:responsibility])
      redirect_to responsibilities_url, notice: "Kunskapsområdet uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @responsibility = Responsibility.find(params[:id])
    @responsibility.destroy
    redirect_to responsibilities_url, notice: "Kunskapsområdet togs bort"
  end

  # Used for autocomplete and search results in edit
  def search
    @responsibilities = Responsibility.where("name like ?", "%#{params[:term]}%").order(:name).limit(50)

    respond_to do |format|
      format.html
      format.json {
        render json: @responsibilities.map { |s| { id: s.id, value: s.name } }
      }
    end
  end

  # Used in the user profile
  def suggest
    @responsibilities = Responsibility.where("name like ?", "%#{params[:q]}%").order(:name).limit(50)

    # Let user add new responsibility
    @responsibilities.unshift Responsibility.new(name: params[:q])

    # We use the :name as :id
    @responsibilities.map! { |l| { id: l.name, name: l.name } }

    render json: @responsibilities
  end
end
