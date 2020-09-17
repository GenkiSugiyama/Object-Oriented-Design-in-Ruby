# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear

  # 依存関係にあるコードの書き方
  attr_reader :chainring, :cog, :rim, :tire # Wheelクラスのインスタンス作成のためにrim, tireの順に追加で必要な引数を指定

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  # ギアインチを算出するgear_inchesメソッドは「タイヤの直径を計算する」と「ギアインチを算出する」の2つの責任を持っていたので分割
  def gear_inches
    ratio * Wheel.new(rim, tire).diameter # Gearのメソッド内でWheelクラスのインスタンスを作りWheelクラスに応答するdiameterを呼び出し
  end

  # 「車輪の円周を算出したい」というWheelクラスを独立させる明確なニーズが出たので分離させる
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

puts Gear.new(52, 11, 26, 2).gear_inches