require File.dirname(__FILE__) + '/../spec_helper'

describe GameDiyWar::WarScene do
  before(:each) do
    p=Player.new
    p.id=1
    p.user_id =1
    p.name="xxoo"
    p.save
    #    GameDiyWar::Output.start
  end
  describe "base test:" do
    before(:each) do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.load_scene
    end
    describe "before start:" do
      it " par will be right " do
        @ws.adventurer_id.should == @id
        @ws.scene_type.should == :train
        @ws.adventurer_ids.should == [@id]
      end
    end

    describe "after start:" do
      before(:each) do
        @ws.start
      end
      it " Scene will create 1  Fighter will create 2 " do
        Scene.count.should == 1
        Fighter.count.should == 2
      end

      it " init var will be right " do
        @ws.adventurer_id.should == @id
        @ws.scene_type.should == :train
        @ws.adventurer_ids.should == [@id]
        @ws.round.should == 1
        @ws.output.should == nil
        @ws.over.should == false
      end

      it "fighters will be 2" do
        @ws.actors.count.should == 2
      end

      describe "load:" do
        before(:each) do
          @loadws = GameDiyWar::WarScene.load(@id)
        end

        it "Scene and Fighter will be 1 and 2 too" do
          Scene.count.should == 1
          Fighter.count.should == 2
        end

        it "old instance var will be equals to new instance" do
          @ws.adventurer_id.should == @loadws.adventurer_id
          @ws.scene_type.should == @loadws.scene_type
          @ws.adventurer_ids.should == @loadws.adventurer_ids
          @ws.round.should == @loadws.round
          @ws.output.should == @loadws.output
          @ws.over.should == @loadws.over
        end
      end
    end
  end
  describe "" do
    before(:each) do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      @fighters = Fighter.all
    end

    #    it "hp will be down after 10 times order" do
    #      10.times{@ws.order("-1")}
    #      fighters = @ws.actors
    #      (fighters[0].hp < @fighters[0].hp || fighters[1].hp < @fighters[1].hp).should be_true
    #    end

    it "model will change after save" do
      @ws.order("-1","-1")
      scene    = Scene.first
      scene.round.should == 2
    end

    it "train will over" do
      20.times{@ws.order("-1","-1")}
      scene    = Scene.first
      scene.over.should be_true
    end
  end
  it "skill will be create in 100 times war" do
    @id = Adventurer.create(:job => 1,:player_id => 1).id
    10.times{
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      @fighters = Fighter.all
      @ws.order("-1","-1") until @ws.over
    }
    skill    = Skill.first
    skill.should_not be_nil
    skill.adventurers.first.id.should == @id
  end
end
