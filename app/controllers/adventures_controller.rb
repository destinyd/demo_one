class Adventure::AdventuresController < ApplicationController
  before_filter :with_user
  before_filter :authorize_adventure,:except => [:new,:create]
  before_filter :authorize_new_adventure,:only => [:new,:create]
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
    @jobsnames = GameDiyWar::Constant::jobsnames
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
  
  def train
    scene_type = :train
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws && @ws.scene_type != scene_type
    (@ws = GameDiyWar::WarScene.new(id,scene_type,[id]);
      @ws.start
    ) unless @ws
    @infos=@ws.info
    #    render :text => @infos
  end
  
  def ptrain
    scene_type=:train
    @ws = GameDiyWar::WarScene.load(current_adventurer.id)
    return render :text => "" if @ws.blank? || @ws.scene_type != scene_type
    order=[]
    params[:a].each_value{|v| order.push v}
    @ws.order(*order)
    @infos=@ws.info
  end

  def fight
    scene_type=:fight
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws && @ws.scene_type != scene_type
    (redirect_to wfight_adventures_path;return) unless @ws
    @infos=@ws.info
    session[:round]=@infos[:round]
  end

  def pfight
    #    scene_type=:fight
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    if @ws
      if params[:a]
        if @ws.find_self.action.blank? || @ws.find_self.action.split("\;")[1].blank?
          order=[]
          params[:a].each_value{|v| order.push v}
          @ws.order(*order)
        else
          flash[:notice]="你已经下达指令"
        end
      else
        if @ws.round_over?
          @ws.fight
          @ws.save
        end
      end
    else
      @ws = GameDiyWar::WarScene.load_last_over(id)
    end
    @infos=@ws.info
  end

  def wfight
    scene_type=:fight
    scene_id  = 1
    id  = current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws
    other_id=Wait.other_or_wait(id,scene_id)
    if other_id
      @ws = GameDiyWar::WarScene.new(id,scene_type,[id,other_id])
      @ws.start
      redirect_to :action => :fight
    end
  end

  def sfight
    Wait.destroy_by_adventurer_id(current_adventurer.id)
    redirect_to :action => :index
  end

  def party
    #    scene_type=:adventure
    ad=current_adventurer
    debugger
    unless @party = ad.party
      redirect_to :action => :find_party
      return
    end
    @members = @party.adventurers
  end

  def find_party
    @partys = Wait.partys.map{ |p| [p.name,p.id]}
  end

  def join_party
    @ad = current_adventurer
    @ad.party_id = params[:party_id]
    @ad.save
    redirect_to :action => :adventure
  end

  def party_wait
    scene_id = 3
    @ad = current_adventurer
    @party = @ad.party
    if @party.teamleader != @ad
      index_by_flash '你不是队长'
      return
    end
    Wait.party_wait(@ad,scene_id)
  end

  def party_stop_wait
    scene_id = 3
    ad = current_adventurer
    p.destroy if p=Wait.find(:first, :conditions => { :adventurer_id => ad.party.id,:scene_id => scene_id})
    redirect_to 'adventure'
  end

  def create_party
    debugger
    ad=current_adventurer
    if @party = ad.party
      redirect_to :action => :party
      return
    end
    name = params[:name].strip
    p = Party.find_by_name(name)
    if p
      flash[:error] = "已存在此队伍，请重新创建"
      redirect_to :action => :find_party
      return
    end
    ad.create_party(:name => name,:adventurer_id => ad.id)
    ad.save
    redirect_to :action => :party
  end

  def adventure
    ad=current_adventurer
    unless @party = ad.party
      redirect_to :action => :find_party
      return
    end
  end

  def padventure
    scene_type=:adventure
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws && @ws.scene_type != scene_type
    (@ws = GameDiyWar::WarScene.new(id,scene_type,[id]);
      @ws.start
    ) unless @ws
    @infos=@ws.info
  end

  def solo
    scene_type=:solo
    id=current_adventurer.id
    @ws = GameDiyWar::WarScene.load(id)
    (at_fight(@ws.scene_type);return false) if @ws && @ws.scene_type != scene_type
    (@ws = GameDiyWar::WarScene.new(id,scene_type,[id]);
      @ws.start
    ) unless @ws
    @infos=@ws.info
  end

  def psolo
    scene_type=:solo
    @ws = GameDiyWar::WarScene.load(current_adventurer.id)
    return render :text => "" if @ws.blank? || @ws.scene_type != scene_type
    @ws.fight
    @ws.save
    @infos=@ws.info
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
