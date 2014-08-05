class ColleagueshipsController < ApplicationController
  before_action :require_user

  def search
    term = "%#{params[:term]}%"
    if term.present?
      @colleagues = Colleagueship.search(current_user, term, 20)
    else
      @colleagues = {}
    end
    render json: @colleagues.map { |c|
      {
        id: c.id,
        username: c.username,
        company_short: c.company_short,
        avatar_full_url: c.avatar.url(:mini_quadrat),
        first_name: c.first_name, last_name: c.last_name
      }
    }
  end

  def create
    @colleagueship = current_user.colleagueships.build(colleague_id: params[:colleague_id])
    if @colleagueship.save
      respond_to do |format|
        format.html { render "created", layout: false }
        format.json { render json: { colleagueship_id: @colleagueship.id } }
      end
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
