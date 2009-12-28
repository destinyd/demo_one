class PicksController < ApplicationController
  before_filter :with_user
  before_filter :with_player
  before_filter :with_pick, :except => [:new,:create]
  before_filter :with_pick_game, :except => [:new,:create]
  before_filter :ensure_no_pick, :only => [:new,:create]
  before_filter :title

  def edit
    @subtitle="改造采集场"
    @pick_type = @pick_game.mtype.human_name
    @mtype = ::MATERIAL_TYPES_TO_IDS.clone.delete_if{|k,v| v == @pick.ctype }
    @level_up_money = @pick_game.level_up_money
  end

  def update
    @pick_game.change_pick_type params[:pick][:ctype]
    index_by_flash "改造成功"
  end

  def level_up
    @success  = @player.cost_money(@pick_game.level_up_money)
    if @success
      @pick_game.level_up
      flash[:notice]  = "升级成功"
    else
      flash[:notice]  = "你没有那么多钱"
    end
    redirect_to :controller => :picks
  end

	def index
    @subtitle="采集场"
    @result = @pick_game.result
    @output = @result
  end

  def new
    @subtitle="建立采集场"
    @pick = @player.build_pick
    @mtype = MATERIAL_TYPES_TO_IDS
  end
  
  def create
    @pick = @player.build_pick(params[:pick])
    @pick.picked_at=Time.now
    if @pick.save
      index_by_flash "你的采集场已经建立"
    else
      @mtype = MATERIAL_TYPES_TO_IDS
      render :action => :new
    end
  end

	private
  def with_pick
    @pick ||= @player.pick if @player
    unless @pick
      redirect_to new_pick_path
      false
    end
  end
  def with_pick_game
    @pick_game  = PickGame.new @pick
  end

  def ensure_no_pick
    if @player.pick
      index_by_flash
      false
    end
  end

  def title
    @title = "炼金世界"
  end

end
