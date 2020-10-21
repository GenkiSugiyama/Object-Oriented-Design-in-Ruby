# スーパークラスとなるBicycleクラス、BicycleクラスのサブクラスとなるRoadBike、MountainBikeクラスを定義する
# 中身を書いていたBicycleクラスの名前をRoadBikeに変更し、新しく空のBicycleクラスを作成
class Bicycle
  # 自転車はchainとtire_sizeを持つ
  attr_reader :size, :chain, :tire_size
  
  def initialize(args={}) # RoadBikeクラスから昇格
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size
    # サブクラスの初期化時にsuperを送るのではなく、スーパークラス側でフックメッセージの送信と実装を行う
    post_initialize(args)
  end

  def spares
    # サブクラスの初期化時にsuperを送るのではなく、スーパークラス側でフックメッセージの送信と実装を行う
    { tire_size: tire_size,
      chain: chain}.merge(local_spares)
  end

  def default_tire_size
    raise NotImplementedError, "This #{self.class} cannnot respond to:"
  end

  # サブクラスの初期化時にsuperを送るのではなく、スーパークラス側でフックメッセージの送信と実装を行う
  def post_initialize
    nil
  end

  # サブクラスの初期化時にsuperを送るのではなく、スーパークラス側でフックメッセージの送信と実装を行う
  def local_spares
    {}
  end

  # 全ての自転車はチェーンについて同じ初期値を共有する
  def default_chain
    '10-speed'
  end

end

class RoadBike < Bicycle
  attr_reader :tape_color

  # スーパークラスで実装されたフックメソッドを具象クラスでオーバーライドする
  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  # スーパークラスで実装されたフックメソッドを具象クラスでオーバーライドする
  def local_spares
    {tape_color: tape_color}
  end

  def default_tire_size
    "23"
  end

  # その他のメソッド〜
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  # スーパークラスで実装されたフックメソッドを具象クラスでオーバーライドする
  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  # スーパークラスで実装されたフックメソッドを具象クラスでオーバーライドする
  def local_spares
    {rear_shock: rear_shock}
  end

  def default_tire_size
    "2.1"
  end

end

road_bike = RoadBike.new(
  size: "M",
  tape_color: "red",
  tire_size: "30"
)

puts road_bike.tire_size