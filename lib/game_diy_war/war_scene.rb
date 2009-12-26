module GameDiyWar
  class WarScene
    ROUNDTIME = 30.seconds
    #    SCENES=[:train,:fight,:solo,:adventure,:teamfight]

    attr_accessor :scene_type,:adventurer_ids,
      :adventurer_id,:scene_id,
      :round,:over,:output,
      :actors,:scene_id,:created_at

    def initialize(adventurer_id, scene_type , adventurer_ids) #,scenes=:train
      @adventurer_id ,@scene_type , @adventurer_ids = adventurer_id , scene_type ,adventurer_ids
      @over  = false
      @round = 1
      @actors = []
      @created_at = Time.now
      load_scene
    end



    def start
      id = start_scene
      return nil unless id
      @scene_id = id
      load_actors
    end



    def load_scene
      return nil unless GameDiyWar::Constant::scenes.include?(@scene_type)

      case @scene_type
      when :train then extend GameDiyWar::Scenes::Train
      when :fight  then extend GameDiyWar::Scenes::Fight
      when :solo  then extend GameDiyWar::Scenes::Solo
      when :adventure then extend GameDiyWar::Scenes::Adventure
      end
      true
    end

    def save
      save_scene
    end

    def timeout
      t=((@created_at + ROUNDTIME - Time.now)/1.second).to_i
      t=0 if t<0
      t
    end



    def round_over?
      !@actors.any?{|actor| actor.can_activity? }
    end

    def info
      info_hash.merge(:self => find_self.info).merge(:teammate => find_teammate.map(&:info)).merge(:enemy => find_enemy.map(&:info))
    end

    def info_hash
      {:round => @round,:over => @over,:output => @output,:timeout => timeout}
    end

    def time_up?
      created_at + ROUNDTIME >= Time.now
    end

    def self.load(adventurer_id)
      fighter = Fighter.find(:first,
        :conditions =>{
          :adventurer_id => adventurer_id,
          :over => false
        },
        :include => :scene
      )
      scene = fighter.try(:scene)
      return nil if fighter.blank? || scene.blank?
      ws=GameDiyWar::WarScene.new(fighter.adventurer_id,GameDiyWar::Constant::scenes[scene.scene],scene.fighters.map(&:adventurer_id).uniq)
      ws.scene_id = scene.id
      ws.over  = scene.over
      ws.round = scene.round
      ws.output = scene.output
      ws.created_at = scene.created_at
      ws.load_actors
      ws
    end

    def self.load_last_over(adventurer_id)
      fighter = Fighter.find(:first,
        :conditions =>{
          :adventurer_id => adventurer_id
        },
        :order => "id desc",
        :include => :scene
      )
      scene = fighter.try(:scene)
      return nil if fighter.blank? || scene.blank?
      ws=GameDiyWar::WarScene.new(fighter.adventurer_id,GameDiyWar::Constant::scenes[scene.scene],scene.fighters.map(&:adventurer_id).uniq)
      ws.scene_id = scene.id
      ws.over  = scene.over
      ws.round = scene.round
      ws.output = scene.output
      ws.created_at = scene.created_at
      ws.load_actors
      ws
    end
  end
end
