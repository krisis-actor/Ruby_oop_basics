# frozen_string_literal: true

require_relative 'wagon'

# Грузовой вагон
class CargoWagon < Wagon
  attr_reader :taken_volume, :free_volume

  def initialize(total_volume)
    super('cargo')
    @total_volume = total_volume
    @free_volume = total_volume
    @taken_volume = 0
  end

  def take_volume(volume)
    return false if volume > @free_volume

    @free_volume -= volume
    @taken_volume += volume
  end
end
