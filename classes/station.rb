# frozen_string_literal: true

require_relative '../modules/instance_counter'

# Станция
class Station
  include InstanceCounter
  attr_reader :name, :trains

  class << self
    def all
      @@stations
    end
  end

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
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

  private

  def trains_by(type)
    @trains.select { |train| train.type == type }
  end
end
