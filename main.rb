require_relative 'train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'



menu = 
"Выберите действие:
  1 - Создать станцию
  2 - Создать пассажирский поезд
  3 - Создать грузовой поезд
  4 - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
  5 - Назначать маршрут поезду
  6 - Добавлять вагоны к поезду
  7 - Отцеплять вагоны от поезда
  8 - Перемещать поезд по маршруту вперед и назад
  9 - Просматривать список станций и список поездов на станции
  0 - Выход из программы!"
user_created_stations = []
user_created_trains = []
user_created_routes = []

def read_through(list)
  i = 1
  for item in list
    if item.is_a? Route
      puts "#{i} - #{item.name}"
      i += 1
    elsif item.is_a?(PassengerTrain) || item.is_a?(CargoTrain)
      puts "#{i} - #{item.number}"
      i += 1
    end
  end
end

puts "Добро пожаловать в программу!"
puts menu

loop do
  user_choice = gets.chomp.to_i
  case user_choice
  when 1
    p "Введите название станции"
    user_station_name = gets.chomp.capitalize
    new_station = Station.new(user_station_name)
    user_created_stations << new_station
    puts menu
  when 2
    p "Введите номер поезда"
    user_train_number = gets.chomp
    new_passenger_train = PassengerTrain.new(user_train_number)
    user_created_trains << new_passenger_train
    puts menu
  when 3
    p "Введите номер поезда"
    user_train_number = gets.chomp
    new_cargo_train = CargoTrain.new(user_train_number)
    user_created_trains << new_cargo_train
    puts menu
  when 4
    puts "Вы находитесь в конструкторе маршрута"
    puts "Выберите начальную станцию из списка"
    read_through(user_created_stations)
    user_choice_1 = gets.chomp.to_i - 1
    puts "Начальная станция - #{user_created_stations[user_choice_1].name}"
    puts "Выберите конечную станцию из списка"
    read_through(user_created_stations)
    user_choice_2 = gets.chomp.to_i - 1
    puts "Конечная станция - #{user_created_stations[user_choice_2].name}"
    new_route = Route.new(
      user_created_stations[user_choice_1],
      user_created_stations[user_choice_2])
    #добавлять/удалять промежуточные станции
    user_created_routes << new_route
    #добавить случай когда начальная станция используется 2 раза
  when 5
    puts "Выберите поезд из списка"
    read_through(user_created_trains)
  when 6
    p "test 6"
  when 7
    p "test 7"
  when 8
    p "test 8"
  when 9
    p "test 9"
  else 
    break
  end
end
