module GameDiyWar
  module Scenes
    module Adventure
      #      attr_accessor :a,:b,:c
      SCENE=:adventure
      SCENEID=3
      MINMONSTER=3

      def start_scene
        create
      end

      def fight
        actors = @actors.sort{|a,b| b.mhp <=> a.mhp}
        until @over
          actors.each do |a|
            a.adventure_fight @actors if a.hp > 0
          end
          @over = fight_over?
          @round += 1
        end
        save
      end

      def fight_over?
        find_enemy.all?{|p|p.hp<=0} || find_teammate.all?{|p|p.hp<=0}
      end

      def find_self
        @actors.each do |actor|
          return actor if actor.job != 10 and actor.adventurer_id == @adventurer_id 
        end
      end

      def find_teammate
        myself  = find_self
        @actors.select do |actor|
          actor.side == myself.side
        end
      end

      def find_enemy
        myself = find_self
        @actors.reject do |actor|
          actor.side == myself.side
        end
      end

      def load_actors
        fs = Fighter.find_all_by_scene_id(@scene_id)
        fs.each{|f| @actors << GameDiyWar::Actor.new(f)}
      end

      def create
        adventurers=Adventurer.find(@adventurer_ids)
        scene=Scene.create(:scene => SCENEID)
        max_hp  = 0
        adventurers.each do |adventurer|
          Fighter.create(
            :hp => adventurer.hp ,
            :mhp => adventurer.mhp,
            :job => adventurer.job,
            :weapon_id => adventurer.weapon_id,
            :armor_id => adventurer.armor_id,
            :scene_id => scene.id,
            :adventurer_id => adventurer.id
          )
          max_hp  = adventurer.mhp if adventurer.mhp >max_hp
        end
        (MINMONSTER+rand(2)).times do
          pet = Pet.first(:order => 'rand()',:conditions => ["hp <= ?",max_hp])
          Fighter.create(
            :hp => pet.hp ,
            :mhp => pet.hp,
            :job => 10,
            :side => 1,
            :scene_id => scene.id,
            :adventurer_id => pet.id
          )
        end
        @scene_id = scene.id
      end

      def select_info
        find_self.select_fight_self_info
      end

      def order(*order)
        find_self.order(*order)
        find_enemy[0].random_action
        fight# if round_over?
        save
      end

      def save_scene
        awards if win?
        save_scene_info
        save_fighters_info
      end
    

      def save_scene_info
        scene       = Scene.find(@scene_id)
        scene.round = @round
        scene.over  = @over
        scene.output= @output = Output.output.join("<br />")+"<br />" if Output.output
        scene.save
      end

      def save_fighters_info
        @actors.each(&:save)
      end
      
      def awards
        money = 0
        total = 0
        @actors.each do |a|
          if a.side ==  1
            money +=  a.mhp
            total+=1
          end
        end
        winner  = @actors.select{|a|  a.side  ==  0}
        winner.each do |a|
          a.player.money  +=  money
          a.adventurer.mhp    +=  total
          a.adventurer.hp    +=  total
          a.player.save
          a.adventurer.save
        end
        winner_name = winner.map(&:name)
        Output.get_money(money,winner_name)
        Output.mhp_up(total, winner_name)
      end
      
      protected
      def win?
        @actors.select{|a|  a.side  ==  1}.all?{|a|a.hp <=  0}
      end
    end
  end
end
