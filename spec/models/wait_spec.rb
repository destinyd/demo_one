require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wait do
  before(:each) do
    @valid_attributes = {
      :adventurer_id => 1,
      :scene_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Wait.create!(@valid_attributes)
  end
end
