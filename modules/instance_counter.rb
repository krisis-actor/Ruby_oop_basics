# frozen_string_literal: true

# Подсчет количества экземпляров класса
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  # Метод класса
  module ClassMethods
    attr_accessor :instances
  end

  # Инстанс экземпляра
  module InstanceMethods
    protected

    def register_instance
      self.class.instances ||= 0
      self.class.instances += 1
    end
  end
end
