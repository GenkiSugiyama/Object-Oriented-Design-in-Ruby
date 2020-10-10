# 旅行に使用するロードバイクを表現するBicycleクラスを定義する
class Bicycle
  attr_reader :size, :tape_color

  def initialize(args)
    @size = args[:size]
    @tape_color = args[:tape_color]
  end

  # すげての自転車はデフォルト値として
   # 同じタイヤサイズとチェーンサイズを持つ
  def spares
    {
      chain: "10-speed",
      tire_size: "23",
      tape_color: tape_color
    }
  end

  # その他のメソッド〜
end

bike = Bicycle.new(
  size: "M",
  tape_color: "red"
)

puts bike.size

puts bike.spares