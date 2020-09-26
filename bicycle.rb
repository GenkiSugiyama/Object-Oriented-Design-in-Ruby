# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear

  attr_reader :chainring, :cog, :wheel

  # 依存オブジェクトの注入が難しい場合は依存先クラスのインスタンス作成をクラス内で分離する
  # 引数の順番依存を取り除くためにキーワード引数を使う
  def initialize(**params)
    @chainring = params[:chaining]
    @cog = params[:cog]
    @wheel = params[:wheel]
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    # あるメソッド内に外部メッセージを埋め込んでいるとメソッド内の処理が複雑になるにつれて外部メッセージが変更によるメソッドが壊れるリスクが高まる
    # 外部メッセージを使う場合は専用のメソッド内にカプセル化する
    ratio * diameter
  end

  # 外部メッセージ用のメソッドを作りカプセル化
  def diameter
    wheel.diameter
  end

  # Wheelのインスタンスを作成する用のメソッドを準備する
  def wheel
    @wheel ||= Wheel.new(rim, tire)
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

puts Gear.new(chaining: 52, cog: 11, wheel: Wheel.new(26, 1.5)).gear_inches