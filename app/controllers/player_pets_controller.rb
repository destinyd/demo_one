class PlayerPetsController < ApplicationController
  before_filter :with_user
  before_filter :with_player
  before_filter :with_pet_game
  before_filter :title

  def index
    @player_pets_json = @pet_game.player_pets_json
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @player_pets_json }
    end
  end

  def show
  end

  def new
    unless @pet_game.could_adopt?
      index_by_flash("你已经领养了两只宠物了，不可以贪得无厌哦")
      return 
    end
    @subtitle="领养宠物"
  end


  def create
    @pet_game.adopt params[:id]
    index_by_flash '领养成功.'
  end
#  def destroy
#    @pet = Pet.find(params[:id])
#    @pet.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(pets_url) }
#      format.xml  { head :ok }
#    end
#  end

  def kill
    #现在只能养一天 所以也就是1 + 1 + 1 顶多3级  以后要考虑怎么记录等级
    p=current_player
    @pet = p.playerpets.find(params[:id])
    if @pet.is_self?(session[:player_id]) && !@pet.needs.blank?
      @item= @pet.kill
      @output="宠物#{@pet.pet.name}实物化，获得#{@item.name},#{@pet.hp}个"
      @pet.runout(@output)
      p.get_item(@item.id,"material",@pet.hp)
    end
  end

  def mix
    @player_pet = @pet_game.mix params[:ids]
    @player_pets_json = @pet_game.player_pets_json
  end

  def feed
    @cost = @pet_game.feed(params[:id])
    with_player_pet_json
    render :template => "player_pets/action"
  end

  def play
    @cost = @pet_game.play(params[:id])
    with_player_pet_json
    render :template => "player_pets/action"
  end

#  def pray
#    @pet = Playerpet.find(params[:id])
#    @success=@pet.pray
#  end

  private
  def title
    @title="宠物世界"
  end
  def with_pet_game
    @pet_game = PetGame.new @player
  end
  def could_adopt
    if @pet_game.could_adopt?
      true
    else
      flash[:notice] = '你已经不能在领养了'
      redirect_to :action => :index
      false
    end
  end

  def with_player_pet_json
    @player_pet_json = @pet_game.player_pet_json(params[:id])
  end

end
