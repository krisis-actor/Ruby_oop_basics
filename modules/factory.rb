# frozen_string_literal: true

# Модуль для указания производителя
module Factory
  attr_reader :factory

  def made_by
    puts 'Укажите производителя'
    @factory = gets.chomp.capitalize
  end
end
