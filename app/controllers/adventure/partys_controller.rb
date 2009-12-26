class Adventure::PartysController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure
  #  before_filter :start_fight,:only => [:train,:fight,:adventure]
  SCENE_ID  = 3
  
  def index
    @ad = current_adventurer
    @party = @ad.party
    unless @party
      redirect_to :action => :new
      return
    end
    redirect_to adventure_party_adventures_path if @party && @party.adventurers.length == 5
  end

  def new
    @partys = Wait.partys.map{ |p| [p.name,p.id]}
  end

  def create
    ad=current_adventurer
    if @party = ad.party
      flash[:error] = '你已经有队伍了'
      redirect_to :action => :index
      return
    end
    name = params[:name].strip
    p = Party.find_by_name(name)
    if p
      flash[:error] = "已存在此队伍，请重新创建"
      redirect_to :action => :index
      return
    end
    ad.create_party(:name => name,:adventurer_id => ad.id)
    ad.save
    redirect_to :action => :index
  end

  def update
    @ad = current_adventurer
    @party = @ad.party
    if @party.teamleader == @ad
      ad = @party.adventurers.find(params[:adventurer_id])
      ad.party_id = nil
      ad.save
      flash[:notice]  = "成功将#{ad.name}踢出队伍"
    else
      if @ad.id  == params[:adventurer_id].to_i
        @ad.party_id  = nil
        @ad.save
        flash[:notice]  = '你已经成功离开队伍'
      else
        flash[:error]   = '你没有权限'
      end
    end
    redirect_to adventure_partys_path
  end

  def destroy
    @ad = current_adventurer
    @party = @ad.party
    if @party.teamleader != @ad
      index_by_flash '你不是队长'
      return
    end
    @party.destroy
    flash[:notice] = "成功解散队伍"
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

  #  def start_fight
  #    true
  #  end
end
