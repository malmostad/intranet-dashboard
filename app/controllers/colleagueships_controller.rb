class ColleagueshipsController < ApplicationController
  before_filter :require_user

  def search
    term = "%#{params[:term]}%"
    if term.present?
      @colleagues = Colleagueship.search(current_user, term, 20)
    else
      @colleagues = {}
    end
    render json: @colleagues.map { |c|
      email = (c.email.present? ? c.email : "ingen e-postaddress").downcase
      { id: c.id, username: c.username, email: email, avatar_full_url: "#{avatar_full_url(c.username, :mini_quadrat)}", first_name: c.first_name, last_name: c.last_name }
    }
  end

  def create
    @colleagueship = current_user.colleagueships.build(colleague_id: params[:colleague_id])
    if @colleagueship.save
      render "created", layout: false
    else
      render "failed", layout: false
    end
  end

  def destroy
    @colleagueship = current_user.colleagueships.find(params[:id])
    @colleagueship.destroy
    render json: { status: :deleted }
  end
end
