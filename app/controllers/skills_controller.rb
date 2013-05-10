# -*- coding: utf-8 -*-
class SkillsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") if admin? }
  before_filter :require_user
  before_filter :require_admin, except: [:search, :suggest]

  def index
    @skills = Skill.order(:name)
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
    redirect_to skills_url, notice: "Kunskapsområdet togs bort"
  end

  # Used for autocomplete and search results in edit
  def search
    term = "%#{params[:term]}%"
    @skills = Skill.where("name like ?", term).order(:name).limit(50)

    respond_to do |format|
      format.html
      format.json {
        render json: @skills.map { |s| { id: s.id, value: s.name } }
      }
    end
  end

  # Used in the user profile
  def suggest
    q = "%#{params[:q]}%"

    @skills = Skill.where("name like ?", q).order(:name).limit(50)

    # Let user add new skill
    @skills.unshift Skill.new(name: params[:q].downcase)

    # We use the :name as :id
    @skills.map! { |l| { id: l.name, name: l.name } }

    render json: @skills
  end
end
