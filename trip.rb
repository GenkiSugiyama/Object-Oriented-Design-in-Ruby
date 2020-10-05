# 旅行の準備が複雑になり、TripCordinatorとDriverが必要となった場合
# それぞれが責任を負う振る舞いを持たせて引数から正しい振る舞いを引き出すことにしてTripクラスのメソッドも変更する
# →Tripクラス内でTripCordinatorクラスとDriverクラスへ直接参照してしまい変更の可能性が急激に上昇してしまう

# 具体的なオブジェクトを参照するのではなく、抽象的なPreparer(準備する者)オブジェクトに対してメッセージを送る
# 送るメッセージはprepare_bicyclesのような具体的なモノではなく「旅行を準備する」意味の「prepare_trip」
# そしてMechanicはじめ具体的なクラスはPreparerのように振舞うためにprepare_tripメソッドを実装する


class Trip
  attr_reader :bicycles, :customers, :vehicle

  # より抽象的なPrepareに対して旅行を準備してもらうためのメッセージを送る
  def perepare(prepares)
    prepares.each {|prepare| 
      prepare_trip(self)
    }
  end
end

# 以下、各クラスはそれぞれがPrepareのように振舞う→prepare_tripに応答するダックのように振舞う
class TripCordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
  ・
  ・
end

def Driver
  def prepare_trip(trip)
    vehicle = trip.vehicle
    gas_up(vehicle)
    fill_water_tank(vehicle)
    ・
    ・
  end
end

class Mecanic
  def prepare_trip(trip)
    trip.bicycles.each{|bicycle|
      prepare_bicycle(bicycle)}
    end
    ・
    ・
  end
end