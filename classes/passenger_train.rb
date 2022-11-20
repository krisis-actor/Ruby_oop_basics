# frozen_string_literal: true

require_relative 'train'

# Пассажирский вагон
class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
    self.class.superclass.find(self)
  end
end
