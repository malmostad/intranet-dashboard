# -*- coding: utf-8 -*-

class GroupContactsController < ApplicationController
  before_filter { add_body_class('edit group-contacts') }
  before_filter { sub_layout("admin") }
  before_filter :require_admin

  def index
    @group_contacts = GroupContact.all
  end

  def show
    @group_contact = GroupContact.find(params[:id])
  end

  def new
    @group_contact = GroupContact.new
  end

  def edit
    @group_contact = GroupContact.find(params[:id])
  end

  def create
    @group_contact = GroupContact.new(params[:group_contact])

    if @group_contact.save
      redirect_to @group_contact, notice: 'Group contact was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @group_contact = GroupContact.find(params[:id])

    if @group_contact.update_attributes(params[:group_contact])
      redirect_to @group_contact, notice: 'Group contact was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @group_contact = GroupContact.find(params[:id])
    @group_contact.destroy

    redirect_to group_contacts_url
  end
end
