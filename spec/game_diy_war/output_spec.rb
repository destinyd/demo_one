require File.dirname(__FILE__) + '/../spec_helper'

describe GameDiyWar::Output do
  before(:each) do
    p=Player.new
    p.id=1
    p.user_id =1
    p.name="xxoo"
    p.save
    GameDiyWar::Output.clear
  end
  it "GameDiyWar::UI length will be 4 after a right order" do
    @id = Adventurer.create(:job => 1,:player_id => 1).id
    @ws=GameDiyWar::WarScene.new(@id,:train,[@id])
    @ws.start
    @ws.order("-1","-1")
    GameDiyWar::Output.output.length.should == 2
    Scene.first.output.blank?.should be_false
  end
end

