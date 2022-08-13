# frozen_string_literal: true

# Пассажирский вагон
class PassengerWagon
  attr_reader :type

  def initialize
    @type = 'passenger'
  end
end
