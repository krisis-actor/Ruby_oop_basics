# frozen_string_literal: true

# Валидация созданных объектов класса
module Validation
  def valid?
    validate!
    true
  rescue
    false
  end
end
