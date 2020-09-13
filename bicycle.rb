# chainringとcogというデータとraitoを計算するという振る舞いがを持つ「Gear」とうクラスを作る
class Gear
  attr_reader :chainring, :cog
  def initialize(**params)
    @chainring = params[:chainring]
    @cog = params[:cog]
  end

  def ratio
    chainring / cog.to_f
  end
end

puts Gear.new(chainring: 52, cog: 11).ratio
puts Gear.new(chainring: 30, cog: 27).ratio