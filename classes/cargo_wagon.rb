# frozen_string_literal: true

require_relative 'wagon'

# Грузовой вагон
class CargoWagon < Wagon
  def initialize
    super
    @type = 'cargo'
  end
end
