class Adventure::JobsController < ApplicationController
  before_filter :with_user
  before_filter :authorize_new_adventure
  #  before_filter :start_fight,:only => [:train,:fight,:adventure]
  
  def index
    @a = current_player.adventurer
  end

  def show

  end

  def edit

  end

  def update

  end

  def new
    @jobsnames = GameDiyWar::Constant::select_jobsnames
  end

  def create
    i=GameDiyWar::Constant::jobsnames.index(params[:job]) if GameDiyWar::Constant::jobsnames.include?(params[:job])
    if i.blank?
      flash[:notice]="此职业暂未开放"
      redirect_to :action => :new
      return
    end
    a=current_player.create_adventurer(:job => i)
    session[:adventurer_id]=a.id if a
    index_by_flash "职业选择成功,从现在开始你的职业为#{params[:job]}"
  end

  private
  def authorize_new_adventure
    if current_adventurer
      redirect_to adventure_adventures_path
      return false
    end
    true
  end
end
