class PetsController < ApplicationController
  before_filter :with_user
  before_filter :with_player
  before_filter :with_pet
  before_filter :title

  def show
  end

  def edit
    unless @pet.could_name?(@player.id)
      flash[:notice] = "你不能对它进行命名"
      redirect_to pet_path(@pet)
      return
    end
  end

  # PUT /pets/1
  # PUT /pets/1.xml
  def update
    unless @pet.could_name?(@player.id)
      flash[:notice] = "你不能对它进行命名"
      redirect_to pet_path(@pet)
      return
    end
    @pet.name = params[:pet][:name]

    respond_to do |format|
      if @pet.save!
        flash[:notice] = '宠物命名成功.'
        format.html { redirect_to(pet_path(@pet)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  private
  def title
    @title="宠物世界"
  end

  def with_pet
    @pet = Pet.find params[:id]
  end
end
