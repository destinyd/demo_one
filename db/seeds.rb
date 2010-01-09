#Sign
{
  "VIP"=> {:duration =>1.week,:name => "会员",:prototype => "VIP" }
}.each do |key,value|
  Sign.create value
end

#base Pet
OreElement.create(:name => "矿精",:hp=>100)
WoodElement.create(:name => "阿童木",:hp=>100)
Beast.create(:name => "皮球",:hp=>100)



