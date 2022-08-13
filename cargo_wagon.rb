# frozen_string_literal: true

# Грузовой вагон
class CargoWagon
  attr_reader :type

  def initialize
    @type = 'cargo'
  end
end
