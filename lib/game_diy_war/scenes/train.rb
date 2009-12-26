# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  module Scenes
    module Train
#      attr_accessor :a,:b,:c
      SCENE=:train
      SCENEID=0

      def start_scene
        create
      end

      def fight
        unless @over
          p = find_self
          e = find_enemy[0]
          p.fight_self(e)
          @over = fight_over?
          p.over = e.over = @over
          @round += 1
          p.new_round
          e.new_round
        end
      end

      def fight_over?
        @actors.any?{|a| a.hp<=0 }
      end

      def find_self
        #        i = @actors.index do |actor|
        #          b= actor.adventurer_id == @adventurer_id
        #          b && actor.side == 0
        #          b
        #        end
        #        @actors[i]
        @actors[0]
      end

      def find_teammate
        []
      end

      def find_enemy
        #        i = @actors.index do |actor|
        #          b= actor.adventurer_id == @adventurer_id
        #          b && actor.side == 1
        #          b
        #        end
        #        @actors[i]
        @actors[1].name+="的分身"
        [@actors[1]]
      end

      def load_actors
        fs = Fighter.find_all_by_scene_id(@scene_id)
        fs.each{|f| @actors << GameDiyWar::Actor.new(f)}
      end

      def create
        adventurer=Adventurer.find(@adventurer_id)
        scene=Scene.create
        player=Fighter.create(
          :hp => adventurer.hp ,
          :mhp => adventurer.mhp,
          :job => adventurer.job,
          :weapon_id => adventurer.weapon_id,
          :armor_id => adventurer.armor_id,
          :scene_id => scene.id,
          :adventurer_id => adventurer.id
        )
        enemy=Fighter.create(
          :hp => adventurer.hp ,
          :mhp => adventurer.mhp,
          :job => adventurer.job,
          :weapon_id => adventurer.weapon_id,
          :armor_id => adventurer.armor_id,
          :side => 1,
          :scene_id => scene.id,
          :adventurer_id => adventurer.id
        )
        if player.blank? || enemy.blank?
          player.destroy if player
          enemy.destroy if enemy
          return nil
        end
        player.scene.id
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
        save_scene_info
        save_fighters_info
      end

      def save_scene_info
        scene       = Scene.find(@scene_id)
        scene.round = @round
        scene.over  = @over
        scene.output= @output = Output.output.join("<br />")+"<br />" if Output.output
        scene.save
        #        Output.clear
      end

      def save_fighters_info
        @actors.each(&:save)
      end

    end
  end
end
