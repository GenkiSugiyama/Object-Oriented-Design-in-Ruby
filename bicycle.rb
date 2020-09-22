# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear

  # 依存関係にあるコードの書き方
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    # Wheelインスタンスの作成をGearクラスの外部へ移動することでGearとWheelクラス間の結合が切り離される
    # Gearは変数@wheelに格納された、diameterに応答するオブジェクトであればWheelクラス以外のクラスとも共同作業が可能になった
    ratio * wheel.diameter
  end

end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end

end

puts Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches