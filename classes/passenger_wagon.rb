# frozen_string_literal: true

require_relative 'wagon'

# Пассажирский вагон
class PassengerWagon < Wagon
  attr_reader :free_seats, :taken_seats

  def initialize(total_seats)
    super('passenger')
    @total_seats = total_seats
    @free_seats = total_seats
    @taken_seats = 0
  end

  def take_seat
    return false if @free_seats.zero?

    @taken_seats += 1
    @free_seats -= 1
  end
end
