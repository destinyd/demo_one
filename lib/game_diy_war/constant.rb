# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  class Constant
    class << self
      SCENES=[:train,:fight,:solo,:adventure,:boss,:teamfight]
      SCENESNAMES=["训练","对决","个人冒险","团队冒险","BOSS战","团战"]
      JOBS=[:knight,:swordman,:mage,:archer]
      JOBS[10]=:enemy
      JOBSNAMES=["骑士","剑客","法师"]#,"弓箭手"]
      JOBSNAMES[10]="怪物"
      JOBSHASH={"骑士" => 0,"剑客" => 1,"法师" => 2}#,"弓箭手" => 3}

      def scenes
        SCENES
      end

      def jobs
        JOBS
      end
      def jobsnames
        JOBSNAMES
      end

      def select_jobsnames
        JOBSNAMES[0..2]
      end

      def scenesnames
        SCENESNAMES
      end

    end
  end
end
