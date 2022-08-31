# frozen_string_literal: true

require_relative 'wagon'

# Пассажирский вагон
class PassengerWagon
  def initialize
    super
    @type = 'passenger'
  end
end
