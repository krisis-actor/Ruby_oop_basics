# frozen_string_literal: true

require_relative '../modules/factory'
require_relative '../modules/validation'

# Общий класс вагона
class Wagon
  include Factory
  include Validation
  attr_reader :type

  def initialize(type)
    @type = type
    validate!
    made_by
  end

  protected

  def validate!
    raise 'Задайте тип вагона' if @type.nil?
  end
end
