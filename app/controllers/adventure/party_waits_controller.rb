class Adventure::PartyWaitsController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure
  #  before_filter :start_fight,:only => [:train,:fight,:adventure]

  SCENE_ID = 3
  
  def index
    @a = current_player.adventurer
    @partys = Wait.partys.map{ |p| [p.name,p.id]}
  end

  def new
    @ad = current_adventurer
    @party = @ad.party
    if @party.teamleader != @ad
      index_by_flash '你不是队长'
      return
    end
    Wait.party_wait(@ad,SCENE_ID)
  end

  def create
    @ad = current_adventurer
    @ad.party_id = params[:party_id]
    @ad.save
    redirect_to :controller => :partys
  end

  def destroy
    @ad = current_adventurer
    @party = @ad.party
    if @party.teamleader != @ad
      index_by_flash '你不是队长'
      return
    end
    Wait.party_stop_wait(@ad,SCENE_ID)
    flash[:notice] = "成功退出等待"
    redirect_to adventure_partys_path
  end



  private
  def authorize_adventure
    if current_adventurer.blank?
      redirect_to new_adventure_path
      return false
    end
    true
  end

  def authorize_new_adventure
    if current_adventurer
      redirect_to adventures_path
      return false
    end
    true
  end

  def at_fight(scene_type)
    redirect_to "/adventures/" + scene_type.to_s
    flash[:notice] = "你现在在#{GameDiyWar::Constant.scenesnames[GameDiyWar::Constant.scenes.index(scene_type)]}当中，不能开始其他的战斗"
  end
end
