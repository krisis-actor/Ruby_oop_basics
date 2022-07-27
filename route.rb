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
