class Train
  INIT_SPEED = 0
  INCREMENT_SPEED = 10
  attr_reader :speed,:type,:number

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def speed_up
    #
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def attache_train(wagon)
    @wagons << wagon if @speed == 0 && @type == wagon.type
  end

  # def detache_train
  #   if @speed == 0 &&  != 0
      
  #   end
  # end

  def take_route(route)
    @current_station_index = 0
    @route = route
  end

  def current_station
    @route.route[@current_station_index]
  end

  def prev_station
    unless @route.route.first == current_station
      @route.route[@current_station_index - 1]
    end
  end

  def next_station
    unless @route.route.last == current_station
      @route.route[@current_station_index + 1]
    end
  end

  def move_forward
    return unless next_station
    current_station.send_train(self)
    @current_station_index += 1
    current_station.accept_train(self)
  end

  def move_back
    return unless prev_station
    current_station.send_train(self)
    @current_station_index -= 1
    current_station.accept_train(self)
  end

end
