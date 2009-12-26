class ItemsController < ApplicationController
  before_filter :with_title
  before_filter :with_item
  before_filter :could_name ,:only => [:edit, :update]
  before_filter :known_item, :only => [:show]

  def edit
    @subtitle="材料命名"
  end

  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = '材料命名成功.'
      redirect_to player_items_path
    else
      render :action => "edit"
    end
  end

  def show
    @finder = @item.player
  end

  private
  def with_title
    @title="仓库世界"
  end

  def with_item
    @item = current_player.items.find(params[:id])
  end

  def could_name
    unless @item.could_name?(session[:player_id])
      flash[:notice] =  "你不能更改它的名称"
      redirect_to player_items_path
      false
    end
  end

  def known_item
    @item = current_player.known_items.find(params[:id])
  end
end
