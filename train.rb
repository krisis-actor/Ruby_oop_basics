# frozen_string_literal: true

# Поезд
class Train
  attr_reader :number, :type, :wagons, :route

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def attache_train(wagon)
    @wagons << wagon if @speed.zero? && @type == wagon.type
  end

  def detache_train
    @wagons.pop if @speed.zero? && @wagons.empty?
  end

  def take_route(route)
    @current_station_index = 0
    @route = route
    current_station.accept_train(self)
  end

  def current_station
    @route.route[@current_station_index]
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

  private

  attr_reader :speed

  # Перенес в приватный метод, т.к возможность управлять скоростью поездом не предоставляется пользователю
  def stop
    @speed = 0
  end

  def speed_up
    @speed += 10
  end

  def prev_station
    return if @route.route.first == current_station

    @route.route[@current_station_index - 1]
  end

  def next_station
    return if @route.route.last == current_station

    @route.route[@current_station_index + 1]
  end
end
