class Station
  def initialize(name)
    @name = name
    @trains = {}
  end

  def accept_train(train)
    @trains << train
  end
end

class Route
  def initialize(from_station,to_station)
    @from_station = from_station
    @to_station = to_station
    @passing_station = []
  end

  def add_passing_station(station_name)
    @passing_station << station_name
    puts "Станция '#{station_name}' была добавлена в список промежуточных станций"
  end

  def del_passing_station(station_name)
    @passing_station.delete(station_name)
    puts "Станция '#{station_name}' была удалена из списка промежуточных станций"
  end

  def show_route
    puts @from_station
    @passing_station.each {|station| puts station}
    puts @to_station
  end
end

class Train
  attr_accessor :speed
  attr_reader :wagon_count

  def initialize(number, type_of_train, wagon_count)
    @number = number
    @type_of_train = type_of_train
    @wagon_count = wagon_count
    @speed = 0
    @route = []
    @current_destination = 'TBD'
  end

  def break
    @speed = 0
  end

  def wagon_attache
    if @speed == 0
      @wagon_count += 1
    else
      puts "Перед сцепкой состава остановите поезд!"
    end
    
  end

  def wagon_detach
    if @wagon_count == 0
      puts "В вашем составе больше нет вагонов для отцепки!"
    elsif @speed != 0
      puts "Остановите поезд перед отцепкой вагона!"
    else
      @wagon_count -= 1
    end
  end

  def accept_route(route)
    @route << route.from_station
    @current_destination = route.from_station
    route.passing_station.each { |station| @route << station }
    @route << route.to_station
  end

  def move_forward
    
  end

  def move_back
    
  end
end
