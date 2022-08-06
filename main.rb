require_relative 'train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'

#Переменные, используемые в программе
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
  0 - Выход из программы"
user_created_stations = []
user_created_trains = []
user_created_routes = []

#Методы для DRY
#Выведение пронумерованного списка в зависимости от класса объектов в массиве
def read_through(list)
  i = 1
  for item in list
    if item.is_a? Route
      puts "[#{i}] - [#{item.route.first.name} - #{item.route.last.name}]"
      i += 1
    elsif item.is_a?(PassengerTrain) || item.is_a?(CargoTrain)
      puts "[#{i}] - #{item.number}"
      i += 1
    elsif item.is_a? Station
      puts "[#{i}] - #{item.name}"
      i += 1
    end
  end
end

def check_on_repeat(created_item,item_array)
  if created_item.is_a?(Station)
    user_created_stations_names = []
    item_array.each { |station| user_created_stations_names << station.name }
    if user_created_stations_names.include? created_item.name
      puts "Станция с таким названием уже создана!"
    else
      item_array << created_item
      puts "Станция #{created_item.name} создана!"
    end
  elsif created_item.is_a?(PassengerTrain) || created_item.is_a?(CargoTrain)
    user_created_trains_numbers = []
    item_array.each { |train| user_created_trains_numbers << train.number }

    if user_created_trains_numbers.include? created_item.number
      puts "Поезд с таким номером уже создан!"
    else
      item_array << created_item
      puts "Поезд #{created_item.number} создан!"
    end
  end
end

#Приветствие
puts "Добро пожаловать в программу!"
puts menu

#Тело программы
loop do
  user_choice = gets.chomp.to_i
  case user_choice
  when 1
    puts "Введите название станции"
    user_station_name = gets.chomp.capitalize
    new_station = Station.new(user_station_name)
    check_on_repeat(new_station,user_created_stations)
    puts menu
  when 2
    puts "Введите номер поезда"
    user_train_number = gets.chomp
    new_passenger_train = PassengerTrain.new(user_train_number)
    check_on_repeat(new_passenger_train,user_created_trains)
    puts menu
  when 3
    puts "Введите номер поезда"
    user_train_number = gets.chomp
    new_cargo_train = CargoTrain.new(user_train_number)
    check_on_repeat(new_cargo_train,user_created_trains)
    puts menu
  when 4
    puts "Вы находитесь в конструкторе маршрута"
    puts "[1] - Создать новый маршрут\n [2] - Редактировать существующий маршрут"
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      puts "Выберите начальную станцию из списка"
      read_through(user_created_stations)
      user_choice_1 = gets.chomp.to_i - 1
      puts "Начальная станция - #{user_created_stations[user_choice_1].name}"
      puts "Выберите конечную станцию из списка"
      user_created_stations_route_end = user_created_stations.reject { 
        |element| element == user_created_stations[user_choice_1] }
      read_through(user_created_stations_route_end)
      user_choice_2 = gets.chomp.to_i - 1
      puts "Конечная станция - #{user_created_stations_route_end[user_choice_2].name}"
      new_route = Route.new(
        user_created_stations[user_choice_1],
        user_created_stations_route_end[user_choice_2])
      puts "[1] - Добавить промежуточную станцию\n[2] - Удалить промежуточную станцию\n[3] - Выход из конструктора маршрута"
      user_choice = gets.chomp.to_i
      case user_choice
      when 1
        user_choice = gets.chomp.capitalize
        new_route.add_passing_station(user_choice)
      when 2
        user_choice = gets.chomp.capitalize
        new_route.del_passing_station(user_choice)
      when 3
        break
      end
    when 2
      read_through(user_created_routes)
      user_choice = gets.chomp.to_i - 1
      selected_route = user_created_routes[user_choice]
    end
    
    user_created_routes << new_route
    puts menu
  when 5
    puts "Выберите поезд из списка"
    read_through(user_created_trains)
    user_choice = gets.chomp.to_i - 1
    selected_train = user_created_trains[user_choice]
    puts "Выберите маршрут из списка"
    read_through(user_created_routes)
    user_choice = gets.chomp.to_i - 1
    selected_route = user_created_routes[user_choice]
    selected_train.take_route(selected_route)
    puts "Поезду #{selected_train.number} присвоен маршрут [#{selected_route.route.first.name}-#{selected_route.route.last.name}]"
    puts menu
  when 6
    puts "Выберите поезд"
    read_through(user_created_trains)
    user_choice = gets.chomp.to_i - 1
    if user_created_trains[user_choice].type == 'passenger'
      wagon = PassengerWagon.new
      user_created_trains[user_choice].attache_train(wagon)
      puts "\tПоезд #{user_created_trains[user_choice].number},
      \tВагонов #{user_created_trains[user_choice].wagons.size}"
    else
      wagon = CargoWagon.new
      user_created_trains[user_choice].attache_train(wagon)
      puts "\tПоезд #{user_created_trains[user_choice].number},
      \tВагонов #{user_created_trains[user_choice].wagons.size}"
    end
    puts menu
  when 7
    puts "Выберите поезд"
    read_through(user_created_trains)
    user_choice = gets.chomp.to_i - 1
    if user_created_trains[user_choice].detache_train
      puts "В составе осталось #{user_created_trains[user_choice].wagons.size}"
    else
      puts "У состава больше нет вагонов!"
    end
    puts menu
  when 8
    puts "Выберите поезд"
    read_through(user_created_trains)
    user_choice_1 = gets.chomp.to_i - 1
    puts "В какую сторону едем?\nВперед - 1\nНазад - 2"
    user_choice_2 = gets.chomp.to_i
    case user_choice_2
    when 1
      user_created_trains[user_choice_1].move_forward
      puts "Вы на станции #{user_created_trains[user_choice_1].current_station.name}"
    when 2
      user_created_trains[user_choice_1].move_back
      puts "Вы на станции #{user_created_trains[user_choice_1].current_station.name}"
    end
    puts menu
  when 9
    puts "Выберите станцию из списка: "
    read_through(user_created_stations)
    user_choice = gets.chomp.to_i - 1
    puts "На станции #{user_created_stations[user_choice].name}: 
    #{user_created_stations[user_choice].count_by('cargo')} грузовых поездов
    #{user_created_stations[user_choice].count_by('passenger')} грузовых поездов"
  when 0
    break
  else 
    puts "Мисклик!"
  end
end
