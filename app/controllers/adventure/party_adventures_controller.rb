class Adventure::PartyAdventuresController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure
  #  before_filter :start_fight,:only => [:train,:fight,:adventure]
  SCENE_TYPE = :adventure

  def index
    id=current_adventurer.id
    ids = current_adventurer.party.adventurer_ids
    @ws = GameDiyWar::WarScene.new(id,SCENE_TYPE,ids);
    @ws.start
    @ws.fight
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
    redirect_to "/adventures/" + scene_type.to_s
    flash[:notice] = "你现在在#{GameDiyWar::Constant.scenesnames[GameDiyWar::Constant.scenes.index(scene_type)]}当中，不能开始其他的战斗"
  end

  #  def start_fight
  #    true
  #  end
end
