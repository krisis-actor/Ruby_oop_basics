# frozen_string_literal: true

require_relative 'train'

# Грузовой поезд
class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end
end
