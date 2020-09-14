# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear
  # 車輪の大きさによる車輪1回転分の進む距離を算出するための属性（rim, tire）を追加
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = params[:chainring]
    @cog = params[:cog]
    @rim = params[:rim]
    @tire = params[:tire]
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  # ギアインチ（車輪の直径×ギア比：ペダル1漕ぎにおける進む距離を算出）
  # 車輪の直径は 「リムの直径　+ タイヤの厚みの2倍」
  def gear_inches
    ratio * (rim + (tire * 2))
  end
end

# ギア比は同じだが車輪のサイズが異なる2台の自転車のギアインチを比較
puts Gear.new(chainring: 52, cog: 11, rim: 26, tire: 1.5).gear_inches
puts Gear.new(chainring: 52, cog: 11, rim: 24, tire: 1.25).gear_inches

# Gearクラスでgear_inchesメソッドを持たせてrim, tireの値が必要となると
# 以前動いていた下記のコードは「引数が足りない」とエラーになる
puts Gear.new(52, 11).ratio