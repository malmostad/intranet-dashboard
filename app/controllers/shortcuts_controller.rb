# -*- coding: utf-8 -*-
require 'digest/sha1'

class ShortcutsController < ApplicationController
  before_filter { add_body_class('edit') }
  before_filter { sub_layout("admin") }
  before_filter :require_admin

  def index
    @shortcuts = Shortcut.all
  end

  def new
    @shortcut = Shortcut.new
  end

  def edit
    @shortcut = Shortcut.where(id: params[:id]).includes(:roles).first
  end

  def create
    @shortcut = Shortcut.new(params[:shortcut])

    if @shortcut.save
      redirect_to shortcuts_url, notice: "Genvägen skapades"
    else
      render action: "new"
    end
  end

  def update
    @shortcut = Shortcut.find(params[:id])

    if @shortcut.update_attributes(params[:shortcut])
      redirect_to shortcuts_url, notice: "Genvägen uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @shortcut = Shortcut.find(params[:id])
    @shortcut.destroy
    redirect_to shortcuts_url, notice: "Genvägen togs bort"
  end
end
