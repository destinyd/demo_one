class Adventure::TrainsController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure
  #  before_filter :start_fight,:only => [:train,:fight,:adventure]
  SCENE_TYPE =  :train

  def index
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws && @ws.scene_type != SCENE_TYPE
    (@ws = GameDiyWar::WarScene.new(id,SCENE_TYPE,[id]);
      @ws.start
    ) unless @ws
    @infos=@ws.info
  end

  def new
    @jobsnames = GameDiyWar::Constant::jobsnames
  end

  def create
    @ws = GameDiyWar::WarScene.load(current_adventurer.id)
    return render :text => "" if @ws.blank? || @ws.scene_type != SCENE_TYPE
    order=[]
    params[:a].each_value{|v| order.push v}
    @ws.order(*order)
    @infos=@ws.info
  end
  
  private
  def authorize_adventure
    if current_adventurer.blank?
      redirect_to adventure_jobs_path
      return false
    end
    true
  end

  def at_fight(scene_type)
    redirect_to "/adventures/#{scene_type}s"
    flash[:notice] = "你现在在#{GameDiyWar::Constant.scenesnames[GameDiyWar::Constant.scenes.index(scene_type)]}当中，不能开始其他的战斗"
  end

  #  def start_fight
  #    true
  #  end
end
