# frozen_string_literal: true

require_relative 'wagon'

# Грузовой вагон
class CargoWagon < Wagon
  attr_reader :type

  def initialize
    super('cargo')
  end
end
