# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear
  # インスタンス変数は常にアクセサメソッドで包み直接参照しないようにする
  # Rubyではattr_readerによって自動でインスタンス変数のラッパーメソッドが作成される
  attr_reader :chainring, :cog, :wheel
  # 上記のように書くことによって下記の定義をしたことになる
  # インスタンス変数を振る舞い（メソッド）で包んでいればインスタンス変数に変更があった場合でもこのメソッド内のみで再実装すれば良い
  # def chainring
  #   @chainring
  # end

  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  # ギアインチを算出するgear_inchesメソッドは「タイヤの直径を計算する」と「ギアインチを算出する」の2つの責任を持っていたので分割
  def gear_inches
    ratio * wheel.diameter
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

@wheel = Wheel.new(26,1.5)
puts @wheel.circumference

puts Gear.new(52, 11, @wheel).gear_inches

puts Gear.new(52, 11, @wheel).ratio