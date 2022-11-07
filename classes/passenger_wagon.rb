# frozen_string_literal: true

require_relative 'wagon'

# Пассажирский вагон
class PassengerWagon < Wagon
  def initialize
    super('passenger')
  end
end
