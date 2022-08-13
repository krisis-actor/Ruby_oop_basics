# frozen_string_literal: true

# Станция
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
