# スーパークラスとなるBicycleクラス、BicycleクラスのサブクラスとなるRoadBike、MountainBikeクラスを定義する
# 中身を書いていたBicycleクラスの名前をRoadBikeに変更し、新しく空のBicycleクラスを作成
class Bicycle
  # 自転車はchainとtire_sizeを持つ
  attr_reader :size, :chain, :tire_size
  
  def initialize(args={}) # RoadBikeクラスから昇格
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size
  end

  # 全ての自転車はチェーンについて同じ初期値を共有する
  def default_chain
    '10-speed'
  end

  # テンプレートメソッド（共通するメソッド）は全てのクラスに終えいて実装するよう用意する
  # 抽象クラスのBicycleクラスでは具体的なタイヤの初期値は必要ないが、エラー文を出力するメソッドとして定義しておく
  # 分かりやすいエラーメッセージを伴って失敗するコードを書いておくと後から手を加える開発者にとって有益な情報を残せる
  # 新しいサブクラス作成時、default_tire_sizeを実装していないとエラーになるということを明文化しておく
  def default_tire_size
    raise NotImplementedError, "This #{self.class} cannnot respond to:"
  end

end

class Sample < Bicycle
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def initialize(args)
    @tape_color = args[:tape_color]
    super(args)
  end

  def default_tire_size
    "23"
  end

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

  def default_tire_size
    "2.1"
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

# puts mountain_bike.spares

sample = Sample.new