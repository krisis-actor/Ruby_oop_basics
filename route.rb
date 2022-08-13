# frozen_string_literal: true

# Маршрут
class Route
  attr_reader :route, :number

  def initialize(number,from_station, to_station)
    @number = number
    @route = [from_station,to_station]
  end

  def add_passing_station(station)
    @route.insert(-2,station)
  end

  def del_passing_station(station)
    @route.delete(station)
  end
end
