# スーパークラスとなるBicycleクラス、BicycleクラスのサブクラスとなるRoadBike、MountainBikeクラスを定義する
# 中身を書いていたBicycleクラスの名前をRoadBikeに変更し、新しく空のBicycleクラスを作成
class Bicycle
  attr_reader :size # RoadBikeクラスから昇格
  
  def initialize(args={}) # RoadBikeクラスから昇格
    @size = args[:size]
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def initialize(args)
    @tape_color = args[:tape_color]
    super(args) 
  end

  # stylの中身を確認し、if文で振る舞いを分岐させる
  def spares
      { chain: "10-speed",
        tire_size: "23", # ミリメータ
        tape_color: tape_color}
  end

  # その他のメソッド〜
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
    super(args)
  end

  def spares
    super.merge(rear_shock: rear_shock)
  end
end

road_bike = RoadBike.new(
  size: "M",
  tape_color: "red"
)

puts road_bike.spares

mountain_bike = MountainBike.new(
  size: "S",
  front_shock: "Manitou",
  rear_shock: "Fox"
)

puts mountain_bike.spares