# frozen_string_literal: true

require_relative '../modules/instance_counter'

# Маршрут
class Route
  include InstanceCounter
  attr_reader :route, :number

  def initialize(number,from_station, to_station)
    @number = number
    @route = [from_station,to_station]
    register_instance
  end

  def add_passing_station(station)
    @route.insert(-2,station)
  end

  def del_passing_station(station)
    @route.delete(station)
  end
end
