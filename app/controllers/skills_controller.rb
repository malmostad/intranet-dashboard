# -*- coding: utf-8 -*-
class SkillsController < ApplicationController
  before_action { add_body_class('edit') }
  before_action { sub_layout("admin") if admin? }
  before_action :require_user
  before_action :require_admin, except: [:search, :suggest]

  def index
    # Display search form
  end

  def new
    @skill = Skill.new
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def create
    @skill = Skill.new(params[:skill])

    if @skill.save
      redirect_to skills_url, notice: "Kunskapsområdet skapades"
    else
      render action: "new"
    end
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update_attributes(params[:skill])
      redirect_to skills_url, notice: "Kunskapsområdet uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy
    redirect_to skills_url, notice: "Kunskapsområdet raderades"
  end

  # Used for autocomplete and search results in edit
  def search
    term = params[:term] || params[:into]
    @skills = Skill.where("name like ?", "%#{term}%").order(:name)

    respond_to do |format|
      format.html
      format.json {
        render json: @skills.map { |s| { id: s.id, value: s.name } }
      }
    end
  end

  # Used in the user profile
  def suggest
    @skills = Skill.where("name like ?", "%#{params[:q]}%").order(:name).limit(50).to_a

    # Let user add new skill
    @skills.unshift Skill.new(name: params[:q])

    # We use the :name as :id
    @skills.map! { |l| { id: l.name, name: l.name } }

    render json: @skills
  end

  def edit_merge
    @skill = Skill.find(params[:id])
  end

  def merge
    @skill = Skill.find(params[:id])
    @into = Skill.where(name: params[:into]).first

    if @skill.merge @into
      redirect_to skills_url, notice: "#{@skill.name} har slagits ihop med #{@into.name}"
    else
      render action: "edit_merge"
    end
  end
end
