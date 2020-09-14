# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear
  # インスタンス変数は常にアクセサメソッドで包み直接参照しないようにする
  # Rubyではattr_readerによって自動でインスタンス変数のラッパーメソッドが作成される
  attr_reader :chainring, :cog
  # 上記のように書くことによって下記の定義をしたことになる
  # インスタンス変数を振る舞い（メソッド）で包んでいればインスタンス変数に変更があった場合でもこのメソッド内のみで再実装すれば良い
  # def chainring
  #   @chainring
  # end

  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog
  end

  # raiio：ギア比（ペダル1漕ぎで車輪が何回転するかを算出する）
  def ratio
    chainring / cog.to_f
  end

  # ギアインチを算出するgear_inchesメソッドは「タイヤの直径を計算する」と「ギアインチを算出する」の2つの責任を持っていたので分割
  def gear_inches
    raito * diameter
  end

  def diameter
    rim + (tire * 2)
  end
end

class RevealingReferences
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify(data)
  end

  # 直径の計算
  # 「wheelsの値を繰り返し処理する」と「それぞれのwheelの直径を計算する」の2つの責任を持っているのでそれぞれの責任に分割する
  # def diameters
  #   wheels.collect {|cell|
  #     wheel.rim + (wheel.tire * 2)}
  # end
  def diameters
    wheels.collect {|wheel| diameter(wheel)}
  end

  def deameter(wheel)
    wheel.rim + (wheel.tire * 2)
  end
  # Structでいくつかの属性を1まとめにしている（今回はrimとtireを1つの配列としている）
  # 直径の計算に必要な属性を1まとめにするための処理だけを抽出している
  # 2つの属性の値が入った構造体を作り上のinitializeでwheelインスタンスに渡している
  # 外部のデータ構造の変更があった場合もこの箇所だけ変更すれば良い
  Wheel = Struct.new(:rim, :tire)
  def wheelify(data)
    data.collect{|cell|
      Wheel.new(cell[0], cell[1])}
  end

end