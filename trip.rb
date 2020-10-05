# 旅行の準備が複雑になり、TripCordinatorとDriverが必要となった場合
# それぞれが責任を負う振る舞いを持たせて引数から正しい振る舞いを引き出すことにしてTripクラスのメソッドも変更する
# →Tripクラス内でTripCordinatorクラスとDriverクラスへ直接参照してしまい変更の可能性が急激に上昇してしまう

# 具体的なオブジェクトを参照するのではなく、抽象的なPreparer(準備する者)オブジェクトに対してメッセージを送る
# 送るメッセージはprepare_bicyclesのような具体的なモノではなく「旅行を準備する」意味の「prepare_trip」
# そしてMechanicはじめ具体的なクラスはPreparerのように振舞うためにprepare_tripメソッドを実装する


class Trip
  attr_reader :bicycles, :customers, :vehicle

  # 引数の背後にあるクラスを想定したメソッドを作ってしまうと、初期に意図していなかったクラスの引数が必要となった場合
  # 追加の処理が必要となってしまう
  def perepare(prepares)
    prepares.each {|prepare| 
      case preparer
      when Mecanic
        prepare.prepare_bicycles(bicycles)
      when TripCordinator
        prepare.buy_food(customers)
      when Driver
        prepare.fill_water_tank(vehicle)
        prepare.gas_up(vehicle)
      end
    }
  end
end

class TripCordinator
  def buy_food(customers)
  end
end

def Driver
  def gas_up(vehicle)
  end

  def fill_water_tank(vehicle)
  end
end

class Mecanic
  def prepare_bicycles(bicycles)
    bicycles.each{|bicycle| prepare_bicycle(bicycle)}
  end

  def prepare_bicycle(bicycle)
  end
end