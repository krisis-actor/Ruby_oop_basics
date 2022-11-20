# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

# Маршрут
class Route
  include InstanceCounter
  include Validation

  attr_reader :route, :number

  NUMBER_FORMAT = /^\d{3}$/.freeze

  @routes = []

  def self.all
    @routes
  end

  def self.find(new_route)
    raise 'Маршрут с таким номером уже существует!' if @routes.find { |route| route.number == new_route.number }

    @routes << new_route
  end

  def initialize(number, from_station, to_station)
    @number = number
    @route = [from_station, to_station]
    validate!
    self.class.find(self)
    register_instance
  end

  def add_passing_station(station)
    @route.insert(-2, station)
  end

  def del_passing_station(station)
    @route.delete(station)
  end

  protected

  def validate!
    raise 'Неверный номер маршрута' if number !~ NUMBER_FORMAT
    raise 'Задайте начальную станцию' if @route[0].nil?
    raise 'Задайте конечную станцию' if @route[-1].nil?
    raise 'Начальная и конечная станции должны отличаться!' if @route[0] == @route[-1]
  end
end
