class MakesController < ApplicationController
  before_filter :with_user
  before_filter :with_player
  before_filter :title

  def new
#    @materials = @player.materials
    @materials_json = list_json
  end

  def create
    mg = MakeGame.new @player
    @player_item = mg.make(params[:player_item_ids],params[:amounts])
    if @player_item
      @item = @player_item.item
      flash[:notice] =  "合成成功，获得#{@item.class.human_name} '#{@item.name}'"
    else
      flash[:notice] = "合成失败"
    end
    redirect_to :action => :new
  end

#  def destroy
#    begin
#      pe=Playerequip.find(params[:id],:include => :equip)
#    rescue ActiveRecord::RecordNotFound
#      flash[:notice]="找不到此装备!"
#      redirect_to :controller => :equips,:action => :index
#      return
#    end
#    @maketype=Equip.maketype
#    par=pe.equip.par/(2*5)  #取5件 1样一个
#
#    m=Material.find(:all,:limit => 5,:order => "rand()",:conditions =>
##        ["ctype in (?) and (par1+par2)<=? ",
#        @maketype[pe.equip.ctype],par])
#    if m.blank?
#      flash[:notice]="这个破烂啥都分解不出来!"
#      redirect_to :controller => :equips,:action => :index
#      return
#    end
##    pe.destroy
#    tmp="获得材料："
#    m.each do |item|
#      Playermaterial.get_materials(session[:player_id], item.id, pe.num)
#      tmp+= "#{item.name}*#{pe.num} &nbsp;"
#    end
#    flash[:notice]=tmp
#    redirect_to :controller => :equips,:action => :index
#  end

#  def index
#    render :text => list_json
#  end

  private
  def list_json
    hash = {}
    @player.materials.each{|item| hash[item.player_item_id] = {'level' => item.level, 'name' => item.name, 'amount' => item.amount, 'class' => item.class.human_name} }
    hash.to_json
  end

  def title
    @title = "炼金世界"
    @subtitle = "合成"
  end
end
