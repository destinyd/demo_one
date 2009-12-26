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
  describe "give a order:" do
    it "order('-1') @action will be '1:0:横斩;0'" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      actor = @ws.find_self
      actor.order("-1")
      actor.action.should == "1:0:横斩;0"
    end

    it "order('-2') @action will be '2:0:重劈;0'" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      actor = @ws.find_self
      actor.order("-2")
      actor.action.should == "2:0:重劈;0"
    end

    it "order('-3') @action will be '3:0:直刺;0'" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      actor = @ws.find_self
      actor.order("-3")
      actor.action.should == "3:0:直刺;0"
    end
    it "order('0') @action will be '0'" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      actor = @ws.find_self
      actor.order("0","0")
      actor.action.should == "0;0"
    end

    it "enemy random_action should in 3 define order" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      enemy = @ws.find_enemy[0]
      action=enemy.random_action
      ["1:0:横斩","2:0:重劈","3:0:直刺"].include?(
        action.split(";")[0]
      ).should be_true
      ["1","2","3"].include?(
        action.split(";")[1]
      ).should be_true
    end
  end

  describe "full" do
    it "round+=1 or action not nil after order an action" do
      @id = Adventurer.create(:job => 1,:player_id => 1).id
      @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
      @ws.start
      @ws.order("-1","-1")
      (@ws.round ==2 || !@ws.find_self.action.blank?).should be_true
    end
  end

end

