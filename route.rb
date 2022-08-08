class Route

  attr_reader :route

  def initialize(from_station, to_station)
    @route = [from_station,to_station]
  end

  def add_passing_station(station)
    @route.insert(-2,station)
  end

  def del_passing_station(station)
    @route.delete(station)
  end

end
