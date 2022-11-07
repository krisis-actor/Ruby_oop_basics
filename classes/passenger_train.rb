# frozen_string_literal: true

require_relative 'train'

# Пассажирский вагон
class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
  end
end
