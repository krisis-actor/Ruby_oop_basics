# frozen_string_literal: true

require_relative 'train'

# Грузовой поезд
class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = 'cargo'
  end
end
