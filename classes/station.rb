# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

# Станция
class Station
  include InstanceCounter
  include Validation
  attr_reader :name, :trains

  NAME_FORMAT = /[А-Я]{1}[а-я]/.freeze

  class << self
    def all
      @stations #TODO Использовать метод класса для валидации станций через интерфейс
    end
  end

  @stations = []

  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.all << self
    register_instance
  end

  def count_by(type)
    trains_by(type).count
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def train_info(&block)
    @trains.each { |train| block.call(train) } if block_given?
  end

  protected

  def validate!
    raise 'Неверное название станции' if name !~ NAME_FORMAT
    raise 'Задайте имя станции' if @name.nil?
  end

  private

  def trains_by(type)
    @trains.select { |train| train.type == type }
  end
end
