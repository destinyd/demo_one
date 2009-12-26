# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  module Scenes
    module Solo
      SCENE=:solo
      SCENEID=2

      def start_scene
        create
      end

      def fight
        unless @over
          p1=@actors[0]
          p2=@actors[1]
          p1.fight_enemy(p2)
          p2.fight_enemy(p1)
          over = fight_over?
          if over
            Adventurer.kill @adventurer_id if find_self.hp > 0
            @over = over
            @actors.each{|actor| actor.over = over}
          end
          next_round
        end
      end

      def fight_over?
        @actors.any?{|a| a.hp<=0 }
      end

      def find_self
#        i = @actors.index do |actor|
#          actor.adventurer_id == @adventurer_id
#          #          b && actor.side == 0
#          #          b
#        end
        @actors[0]
      end

      def find_teammate
        []
      end

      def find_enemy
#        i = @actors.index{|actor| actor.adventurer_id != @adventurer_id}
        [@actors[1]]
      end

      def load_actors
        fs = Fighter.find_all_by_scene_id(@scene_id)
        fs.each{|f| @actors << GameDiyWar::Actor.new(f)}
      end

      def create
        adventurer = Adventurer.find(@adventurer_id)
        scene=Scene.create(:scene => SCENEID)
        pet = Pet.find(:first,:order => "rand()")
        Fighter.create(
          :hp => adventurer.hp ,
          :mhp => adventurer.mhp,
          :job => adventurer.job,
          :weapon_id => adventurer.weapon_id,
          :armor_id => adventurer.armor_id,
          :scene_id => scene.id,
          :adventurer_id => adventurer.id
        )
        Fighter.create(
          :hp => pet.hp ,
          :mhp => pet.hp,
          :job => 10,#enemy
          :side => 1,
          :scene_id => scene.id,
          :adventurer_id => pet.id
        )


        #        return nil if fighters.blank?
        scene.id
      end

      def order(*order)
        fight
        save
      end

      def save_scene
        save_scene_info
        save_fighters_info
      end

      def save_scene_info
        scene       = Scene.find(@scene_id)
        scene.round = @round
        scene.over  = @over
        if Output.output.blank?
          scene.output= @output = ""
        else
          scene.output= @output = Output.output.join("<br />")+"<br />"
        end
        scene.created_at = @created_at
        scene.save
      end

      def save_fighters_info
        @actors.each(&:save)
      end


      def next_round
        @round += 1
        @actors.each{ |actor|
          actor.new_round
        }
        @created_at = Time.now
      end

    end
  end
end
