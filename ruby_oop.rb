class Station

  attr_reader :trains_total, :train_passenger, :trains_freight

  def initialize(name)
    @name = name
    @trains_total = []
    @trains_passenger = []
    @trains_freight = []
    puts "Станция #{name} создана!"
  end

  def show_all_trains
    puts "Поезда на станции:"
    for train in @trains_total
      puts "#{train.number}"
    end
  end

  def show_train_type_number
    puts "Количество пассажирских поездов #{@trains_passenger.length}"
    puts "Количество пассажирских поездов #{@trains_freight.length}"
  end

  def accept_train(train)
    @trains_total << train
    puts "#{train.train_type.capitalize} поезд #{train.number} прибыл на станцию!"
    if train.train_type == 'пассажирский'
      @trains_passenger << train
    else
      @trains_freight << train
    end 
  end

  def send_train(number)
    trains_on_station_number = []
    for train in @trains_total 
      trains_on_station_number << train.number
    end
    if trains_on_station_number.include?(number)
      puts "Поезд №#{number} отправился в путь!"
      for train in @trains_total
        case train.train_type
        when 'пассажирский'
          @trains_total.delete(train)
          @trains_passenger.delete(train)
        when 'грузовой'
          @trains_total.delete(train)
          @trains_freight.delete(train)
        end
      end
    else
      puts "Ошибка! Поезда с таким номером нет на станции!"
    end
  end

end

class Train

  attr_reader :speed,:wagon_number, :train_type, :number

  def initialize(number,train_type,wagon_number)
    @number = number
    @train_type = train_type
    @wagon_number = wagon_number
    @speed = 0
    puts "Создан #{@train_type} поезд
          Номер - #{@number}
          Количество вагонов - #{@wagon_number}шт"
  end

  def speed_up
    @speed += 10
    puts "Скорость - #{@speed} км/ч"
  end

  def stop
    @speed = 0
  end

  def attache_train
    if @speed == 0
      @wagon_number += 1
      puts "Количество вагонов в составе #{@wagon_number} шт."
    else
      puts "Остановите поезд!"
    end
  end

  def detache_train
    if @speed == 0
      if @wagon_number == 0 
        puts "В составе больше нет вагонов!"
      else
        @wagon_number -= 1
        puts "Количество вагонов в составе #{@wagon_number} шт." 
      end
    else
      puts "Остановите поезд!"
    end
  end

  def take_route(route)
    @route_start = route.from_station
    @route_end = route.to_station
    @route = route.whole_route
    @route_index = 0
  end

  def move_forward
    if @route[@route_index] == @route_end
      puts "Вы находитесь на конечной станции! Поезд дальше не идет!"
    else
      @route_index+=1
    end
  end

  def move_back
    if @route[@route_index] == @route_start
      puts "Вы находитесь на конечной станции! Поезд дальше не идет!"
    else
      @route_index-=1
    end
  end

  def stations_return
    puts "Предыдущая станция: #{@route[@route_index-1]}"
    puts "Текущая станция: #{@route[@route_index]}"
    puts "Следующая станция: #{@route[@route_index+1]}"
  end

end

class Route

  attr_reader :whole_route, :from_station, :to_station

  def initialize(from_station, to_station)
    @from_station = from_station
    @to_station = to_station
    @passing_station = []
    @whole_route = [@from_station, @to_station]
    puts "Маршрут создан! 
          Начальная станция #{@from_station}
          Конечная станция #{@to_station}"    
  end

  def add_passing_station(station_name)
    @passing_station << station_name
    @whole_route.insert(-2, station_name)
    puts "Станция #{station_name} добавлена в список промежуточных станций!"
  end

  def del_passing_station(station_name)
    @passing_station.delete(station_name)
    @whole_route.delete(station_name)
    puts "Станция #{station_name} удалена из списка промежуточных станций!"
  end

  def print_route
    @whole_route.each { |station| puts station }
  end

end
