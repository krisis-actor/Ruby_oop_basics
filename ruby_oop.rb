class Station

  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains_by(type)
    @trains.select { |train| train.type == type }
  end

  def count_by(type)
    trains_by(type).count
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

end

class Train

  attr_reader :speed,:type

  def initialize(number,type,wagon_number)
    @number = number
    @type = type
    @wagon_number = wagon_number
    @speed = 0
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def attache_train
    unless @speed != 0
      @wagon_number +=1
    end
  end

  def detache_train
    if @speed == 0 && @wagon_number != 0
      @wagon_number -= 1
    end
  end

  def take_route(route)
    @current_station = 0
    @route = route
  end

  def current_station
    @route.route[@current_station]
  end

  def prev_station
    unless @route.route.first == current_station
      @route.route[@current_station - 1]
    end
  end

  def next_station
    unless @route.route.last == current_station
      @route.route[@current_station + 1]
    end
  end

  def move_forward
    unless @route.route.last == current_station
      @current_station += 1
    end
  end

  def move_back
    unless @route.route.first == current_station
      @current_station -= 1
    end
  end

end

class Route

  attr_reader :route

  def initialize(from_station, to_station)
    @route = [from_station,to_station]
  end

  def add_passing_station(station_name)
    @route.insert(-2,station_name)
  end

  def del_passing_station(station_name)
    @route.delete(station_name)
  end

end
