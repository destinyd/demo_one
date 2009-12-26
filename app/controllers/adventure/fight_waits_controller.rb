class Adventure::FightWaitsController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure
  SCENE_TYPE=:fight

  def index

    scene_id  = 1
    id  = current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws
    other_id=Wait.other_or_wait(id,scene_id)
    if other_id
      @ws = GameDiyWar::WarScene.new(id,SCENE_TYPE,[id,other_id])
      @ws.start
      redirect_to adventure_fights_path
    end
  end

  def destroy
    Wait.destroy_by_adventurer_id(current_adventurer.id)
    redirect_to adventure_adventures_path
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

  #  def start_fight
  #    true
  #  end
end
