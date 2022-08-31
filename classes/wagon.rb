# frozen_string_literal: true

require_relative '../modules/factory'

# Общий класс вагона
class Wagon
  include Factory
  attr_reader :type

  def initialize
    @type = nil
    made_by
  end
end
