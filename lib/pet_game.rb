class PetGame
  @@max_pets_count = 2
  @@percent_per_action = 0.05
  @@percent_per_hour = 0.02
  @@hp_percent_per_hour = 0.01
  @@init_food_percent = 0.8
  @@init_happy_percent = 0.5
  @@max_multiple = 2

  attr_reader :pets_count

  def initialize(player)
    @player = player
    @player_pets = player.player_pets
    @pets_count = @player_pets.count
    all_grow
  end

  def player_pets_json
    hash = {}
    @player_pets.each do |player_pet| 
      hash[player_pet.id] = {
        :id => player_pet.id,
        :hp => player_pet.hp, 
        :basehp => player_pet.basehp,
        :food => player_pet.food,
        :happy => player_pet.happy,
        :name => player_pet.name,
        :class => player_pet.race_name,
        :pet_id => player_pet.pet_id
      }
    end
    hash.to_json
  end

  def player_pet_json(player_pet_id)
    player_pet = find_player_pet player_pet_id
    hash = {}
    hash[player_pet.id] = {
      :hp => player_pet.hp, 
      :basehp => player_pet.basehp,
      :food => player_pet.food,
      :happy => player_pet.happy,
      :name => player_pet.name,
      :class => player_pet.race_name,
      :pet_id => player_pet.pet_id
    }
    hash.to_json
  end

  def play(player_pet_id)
    player_pet = find_player_pet player_pet_id
    cost = action_cost(player_pet)
    if @player.cost_money(cost)
      player_pet.happy += cost
      player_pet.happy = player_pet.hp if player_pet.happy > player_pet.hp
     return cost if player_pet.save!
    end
  end

  def feed(player_pet_id)
    player_pet = find_player_pet player_pet_id
    cost = action_cost(player_pet)
    if @player.cost_money(cost)
      player_pet.food += cost
      player_pet.food = player_pet.hp if player_pet.food > player_pet.hp
      return cost if player_pet.save!
    end
  end

  def adopt(pet_id)
    pet_id = pet_id.to_i
    raise 'you can adopt this pet' if pet_id.class != Fixnum or pet_id < 1 or pet_id > 3
    raise 'you can adopt so many pets' unless could_adopt?
#    @pets_count += 1
    pet = Pet.find(pet_id)
#    hp = pet.hp
#    food = (0.8*hp).to_i
#    happy = (0.5*hp).to_i
#    player_pet = @player.player_pets.create(
#      :hp => hp, :food => food, :happy => happy,
#      :pet_id => pet.id, :grow_at  => Time.now
#    )
#    @player_pets.push player_pet
#    player_pet
    get_pet(pet)
  end

  def could_adopt?
    @pets_count + 1 <= @@max_pets_count
  end

  def mix(player_pet_ids)
    player_pets = []
    player_pet_ids.each do |player_pet_id| 
      player_pets.push find_player_pet(player_pet_id)
    end
    player_pets = player_pets.compact
    raise "#{@player.name} has no these pets" unless has_player_pets?(player_pets) and player_pet_ids.count == player_pets.count
    raise "mix must greater or equal 2 pets" if player_pets.count < 2
    race = []
    total_hp = 0
    player_pets.each do |player_pet|
      race.push player_pet.race
      total_hp += player_pet.hp
      player_pet.destroy
      @player_pets.delete player_pet
    end
    @pets_count -= player_pets.count
    hp = (total_hp / player_pets.count).round
    race = race.uniq.rand
    pet = race.mix(@player.id,hp)
    get_pet(pet)
  end

  def kill

  end

  private
  def find_player_pet(player_pet_id)
    player_pet_id = player_pet_id.to_i
    @player_pets.select{|player_pet| player_pet.id == player_pet_id}[0]
  end

  def get_pet(pet)
    hp = pet.hp
    food = hp * @@init_food_percent
    food = food.round
    happy = hp * @@init_happy_percent
    happy = happy.round
    @pets_count += 1
    player_pet = 
      @player.player_pets.create(
      :hp => pet.hp,
      :food => food,
      :happy => happy,
      :pet_id => pet.id,
      :grow_at => Time.now
      )
    @player_pets.push player_pet
    player_pet
  end

  def has_player_pets?(player_pets)
    bool = true
    player_pets.each do |player_pet|
      bool = bool and @player_pets.include? player_pet
    end
    bool
  end

  def run_away(player_pet)
    @player_pets.delete player_pet
    player_pet.destroy
    @pets_count -= 1
  end

  def grow(player_pet)
    grow_time = ((Time.now - player_pet.grow_at) / 1.hour).to_i
    return if grow_time < 1
    player_pet.grow_at += grow_time.hours
    grow_point = (player_pet.hp * @@percent_per_hour * grow_time).round
    grow_hp_percent = (1 + @@hp_percent_per_hour) ** grow_time
    player_pet.hp = (player_pet.hp * grow_hp_percent).to_i
    max_hp = player_pet.basehp * @@max_multiple
    player_pet.hp = player_pet.basehp * max_hp if player_pet.hp > max_hp
    player_pet.food -= grow_point
    player_pet.happy -= grow_point
    return hungry(player_pet) if player_pet.food <= 0
    return unhappy(player_pet) if player_pet.happy <= 0
    player_pet.save! if player_pet.changed?
  end

  def all_grow
    @player_pets.each{|player_pet| grow(player_pet)}
  end
  
  def hungry(player_pet)
    name = player_pet.name
    run_away(player_pet)
    @player.do_now "你的#{name}被饿死了"
  end

  def unhappy(player_pet)
    name = player_pet.name
    run_away(player_pet)
    @player.do_now "你的#{name}十分不开心的跑掉了"
  end

  def action_cost(player_pet)
    ( player_pet.hp * @@percent_per_action).round
  end
end
