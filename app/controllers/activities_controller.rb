# -*- coding: utf-8 -*-
class ActivitiesController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin, except: [:search, :suggest]

  def index
    # Display search form
  end

  def new
    @activity = Activity.new
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def create
    @activity = Activity.new(params[:activity])

    if @activity.save
      redirect_to activities_url, notice: "Aktiviteten skapades"
    else
      render action: "new"
    end
  end

  def update
    @activity = Activity.find(params[:id])

    if @activity.update_attributes(params[:activity])
      redirect_to activities_url, notice: "Aktiviteten uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    redirect_to activities_url, notice: "Kunskapsområdet raderades"
  end

  # Used for autocomplete and search results in edit
  def search
    term = params[:term] || params[:into]
    @activities = Activity.where("name like ?", "%#{term}%").order(:name)

    respond_to do |format|
      format.html
      format.json {
        render json: @activities.map { |s| { id: s.id, value: s.name } }
      }
    end
  end

  # Used in the user profile
  def suggest
    @activities = Activity.where("name like ?", "%#{params[:q]}%").order(:name).limit(50)

    # Let user add new activity
    @activities.unshift Activity.new(name: params[:q])

    # We use the :name as :id
    @activities.map! { |l| { id: l.name, name: l.name } }

    render json: @activities
  end

  def edit_merge
    @activity = Activity.find(params[:id])
  end

  def merge
    @activity = Activity.find(params[:id])
    @into = Activity.where(name: params[:into]).first

    if @activity.merge @into
      redirect_to activities_url, notice: "#{@activity.name} har slagits ihop med #{@into.name}"
    else
      render action: "edit_merge"
    end
  end
end
