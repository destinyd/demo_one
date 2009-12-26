class PlayersController < ApplicationController
  before_filter :with_user
  before_filter :with_player,:except => :show
  def index
    @title="我的状态"
  end

  def update
    respond_to do |format|
      if @player.signed != params[:player][:signed]
        if @player.update_attributes!(params[:player])
          @player.do_now("称号更改为'" +@player.signed + "'")
          format.json { render :json => @player }
        else
          format.json { render :json => @player, :status => SOMETHINGELSE_THAN_200}
        end
      else
        format.json { render :json => @player, :status => SOMETHINGELSE_THAN_200}
      end

    end
  end

  def show
    @title="玩家状态"
    begin
      @player=Player.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      index_by_flash("没有此玩家")
    end
  end
  
  in_place_edit_for :player, :signed
end
