require File.dirname(__FILE__) + '/../spec_helper'

describe GameDiyWar::WarScene do
  before(:each) do
    p=Player.new
    p.id=1
    p.user_id =1
    p.name="xxoo"
    p.save

    GameDiyWar::Output.clear
  end
  it "" do
    @ids=[]
    @ids.push Adventurer.create(:job => 1,:player_id => 1).id
    @ids.push Adventurer.create(:job => 1,:player_id => 1).id
    @ws=GameDiyWar::WarScene.new(@ids[0],:fight,[@ids])
    @ws.start
    @ws.created_at = 30.seconds.from_now
    @ws.time_up?.should be_true
  end
end

