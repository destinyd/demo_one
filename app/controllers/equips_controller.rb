class EquipsController < ApplicationController
  before_filter :with_user
  def index
    @ietype=Equip.ietype
    sw=SwordWorld.find(session[:sword_id])
    ids=[]
    ids.push sw.weapon_id if sw.weapon_id
    ids.push sw.armor_id if sw.armor_id
    @equip=[]
    @equip=Equip.find(ids) unless ids.blank?
    @list=Playerequip.paginate :conditions =>
      {:player_id => session[:player_id]}, :order => "islock desc,id desc",
      :per_page => 10,:page => params[:page],:include => :equip
    @title="仓库世界"
    @subtitle="我的装备"
  end

  def create
    ctype=params[:ctype].to_i
    @equip = Playerequip.find(params[:id],:include => :equip)
    if !@equip || @equip.num<1 || @equip.equip.ctype !=ctype
      flash[:notice]='链接出错'
      redirect_to(:action => :index)
      return
    end
    @equip.put_on
    sw=SwordWorld.find(session[:sword_id])

    if ctype==0
      Playerequip.take_off_equip session[:player_id],sw.weapon_id if sw.weapon_id
      sw.weapon_id=@equip.equip_id
      sw.weapon_par=@equip.equip.par
    elsif ctype==1
      Playerequip.take_off_equip session[:player_id],sw.armor_id if sw.armor_id
      sw.armor_id=@equip.equip_id
      sw.armor_par=@equip.equip.par
    end
    sw.save
    flash[:notice]='装备成功'
    redirect_to(:action => :index)
    #@equip.save
  end

  def edit
    @equip = Equip.find(params[:id])
    if @equip.isnamed
      flash[:notice]="此装备已经被命名，不可再更改。"
      redirect_to(:action => :index)
    end
    @title="仓库世界"
    @subtitle="装备命名"
  end

  def update
    @equip = Equip.find(params[:id])
    if @equip.isnamed
      flash[:notice]="此装备已经被命名，不可再更改。"
      redirect_to(:action => :index)
      return
    end
    if @equip.player_id == session[:player_id] || @equip.created_at < 2.hours.ago
      @equip.name=params[:equip][:name]
      #      @equip.isnamed=true
      if @equip.save!
        flash[:notice] = '命名成功'
      else
        flash[:notice] = '命名失败'
      end
    else
      flash[:notice]="装备创造者2小时的命名期还没过，你不能对此装备命名"
    end
    redirect_to(:action => :index)
  end
  def destroy
    if params[:id].blank?
      flash[:notice]="错误!"
      redirect_to :action => :index
      return
    end
    id=params[:id].to_i
    sw=SwordWorld.find(session[:sword_id])
    Playerequip.take_off_equip session[:player_id],id
    sw.take_off_weapon if sw.weapon_id == id
    sw.take_off_armor if sw.armor_id== id
    redirect_to(:action => :index)
  end
end
