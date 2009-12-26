# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  module Scenes
    module Fight
      SCENE=:fight
      SCENEID=1

      def start_scene
        create
      end

      def fight
        unless @over
          p1=@actors[0]
          p2=@actors[1]
          p1.fight(p2)
          p2.fight(p1)
          if fight_over?
            @over = fight_over?
            @actors.each{|actor| actor.over = @over}
            unless @actors[0].hp <= 0 && @actors[1].hp <= 0
              if @actors[0].hp <= 0
                Adventurer.lose @actors[0].adventurer_id
                Adventurer.win @actors[1].adventurer_id
              elsif @actors[1].hp <= 0
                Adventurer.lose @actors[1].adventurer_id
                Adventurer.win @actors[0].adventurer_id
              end
            end
          end
          next_round
        end
      end

      def fight_over?
        @actors.any?{|a| a.hp<=0 }
      end

      def find_self
        i = @actors.index do |actor|
          actor.adventurer_id == @adventurer_id
        end
        @actors[i]
      end

      def find_teammate
        []
      end

      def find_enemy
        i = @actors.index{|actor| actor.adventurer_id != @adventurer_id}
        [@actors[i]]
      end

      def load_actors
        fs = Fighter.find_all_by_scene_id(@scene_id)
        fs.each{|f| @actors << GameDiyWar::Actor.new(f)}
      end

      def create
        #        adventurer=Adventurer.find(@adventurer_id)
        adventurers = Adventurer.find(@adventurer_ids)
        scene=Scene.create(:scene => SCENEID)
        fighters=[]
        adventurers.each{ |adventurer|
          fighters.push Fighter.create(
            :hp => adventurer.hp ,
            :mhp => adventurer.mhp,
            :job => adventurer.job,
            :weapon_id => adventurer.weapon_id,
            :armor_id => adventurer.armor_id,
            :scene_id => scene.id,
            :adventurer_id => adventurer.id
          )
        }
        #        return nil if fighters.blank?
        scene.id
      end

      def select_info
        find_self.select_fight
      end

      def order(*order)
        find_self.order(*order) if @action.blank?
        fight if round_over?
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

      def round_over?
        !@actors.any?{|actor| actor.can_activity? } ||
          (timeout==0  && @actors.any?{|actor| !actor.can_activity? })
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
