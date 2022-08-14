# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'

# Интерфейс программы
class Interface
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @menu = "Выберите действие:
    1. Создать станцию
    2. Создать пассажирский поезд
    3. Создать грузовой поезд
    4. Создать маршрут
    5. Управлять станциями в маршруте
    6. Назначать маршрут поезду
    7. Добавить вагон к поезду
    8. Отцепить вагон от поезда
    9. Перемещать поезд по маршруту вперед и назад
    10. Просмотреть список станций и список поездов на станции"
    start_up
  end
  # Пользователь может пользоваться программой, без внепланового вызова методов класса

  private

  def start_up
    loop do
      railway
    end
  end

  def railway
    puts @menu
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      create_station(@stations)
    when 2
      create_p_train(@trains)
    when 3
      create_c_train(@trains)
    when 4
      create_route(@routes,@stations)
    when 5
      edit_route(
        @routes,
        @stations,
        @trains
      )
    when 6
      set_route_to_train(@trains, @routes)
    when 7
      add_wagon(@trains)
    when 8
      del_wagon(@trains)
    when 9
      move_train(@trains)
    when 10
      station_review(@stations)
    else
      puts 'Мисклик!'
    end
  end
end

def create_station(stations)
  puts 'Введите название станции: '
  new_station = Station.new(gets.chomp.capitalize)
  if stations.find { |station| station.name == new_station.name }
    puts 'Станция с таким названием уже создана!'
  else
    stations << new_station
    puts "Станция #{new_station.name} создана!"
  end
end

def create_p_train(trains)
  puts 'Введите номер поезда'
  new_train = PassengerTrain.new(gets.chomp.capitalize)
  if trains.find { |train| train.number == new_train.number }
    puts 'Поезд с таким номером уже существует!'
  else
    trains << new_train
    puts "Поезд #{new_train.number} создан!"
  end
end

def create_c_train(trains)
  puts 'Введите номер поезда'
  new_train = CargoTrain.new(gets.chomp.capitalize)
  if trains.find { |train| train.number == new_train.number }
    puts 'Поезд с таким номером уже существует!'
  else
    trains << new_train
    puts "Поезд #{new_train.number} создан!"
  end
end

def create_route(routes, stations)
  if stations.size >= 2
    puts 'Введите номер маршрута'
    route_number = gets.chomp.upcase
    if routes.find { |route| route.number == route_number }
      puts 'Маршрут с таким номером уже существует!'
    else
      puts 'Выберите начальную станцию: '
      station_list_read(stations)
      selected_station_1 = stations[gets.chomp.to_i - 1]
      puts 'Выберите конечную станцию: '
      station_list_read(stations)
      selected_station_2 = stations[gets.chomp.to_i - 1]
      if selected_station_1 != selected_station_2
        new_route = Route.new(route_number, selected_station_1,
                              selected_station_2)
        routes << new_route
        puts 'Маршрут создан!'
      else
        puts 'Начальная и конечная станция должны отличаться!'
      end
    end
  else
    puts 'Требуется минимум 2 станции для создания маршрута!'
  end
end

def edit_route( routes,
                stations,
                trains)
  puts 'Выберите маршрут: '
  route_list_read(routes)
  selected_route = routes[gets.to_i - 1]
  puts "1. Добавить станцию\n2. Удалить станцию"
  user_choice = gets.to_i
  case user_choice
  when 1
    stations_filtered =  stations -
                                      selected_route.route
    if stations_filtered.empty?
      puts 'Создайте станцию!'
    else
      station_list_read(stations_filtered)
      selected_station = stations_filtered[gets.to_i - 1]
      selected_route.add_passing_station(selected_station)
      puts 'Станция добавлена!'
      refresh_route(trains, selected_route)
    end
  when 2
    if selected_route.route.size >= 3
      puts 'Выберите промежуточную станцию для удаления: '
      station_list_read(selected_route.route[1..-2])
      selected_station = selected_route.route[gets.to_i - 1]
      selected_route.del_passing_station(selected_station)
      puts 'Станция удалена!'
      refresh_route(trains, selected_route)
    else
      puts 'Нет станций для удаления!'
    end
  end
end

def station_list_read(stations)
  stations.each_with_index do |station, i|
    puts "#{i += 1}. #{station.name}"
  end
end

def train_list_read(trains)
  trains.each_with_index do |train, i|
    puts "#{i += 1}. #{train.number}"
  end
end

def route_list_read(routes)
  routes.each do |route, i|
    puts "#{i += 1}. #{route.number}"
  end
end

def set_route_to_train(trains,routes)
  if trains.empty?
    puts 'Нет созданных поездов'
  else
    puts 'Выберите поезд из списка'
    train_list_read(trains)
    selected_train = trains[gets.to_i - 1]
  end

  if routes.empty?
    puts 'Нет созданных маршрутов'
  else
    puts 'Выберите маршрут из списка'
    route_list_read(routes)
    selected_route = routes[gets.to_i - 1]
    if selected_route == selected_train.route
      puts 'Поезду уже присвоен такой маршрут!'
    else
      selected_train.take_route(selected_route)
      puts 'Маршрут присвоен!'
    end
  end
end

def add_wagon(trains)
  if trains.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд: '
    train_list_read(trains)
    selected_train = gets.chomp.to_i - 1
    wagon = PassengerWagon.new if trains[selected_train].type == 'passenger'
    wagon = CargoWagon.new if trains[selected_train].type == 'cargo'
  end
  trains[selected_train].attache_train(wagon)
  puts 'Вагон добавлен!'
end

def del_wagon(trains)
  if trains.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд'
    train_list_read(trains)
    selected_train = gets.to_i - 1
    if trains[selected_train].detache_train
      puts 'Вагон отцеплен!'
    else
      puts 'У состава больше нет вагонов!'
    end
  end
end

def move_train(trains)
  if trains.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд'
    train_list_read(trains)
    selected_train = gets.to_i - 1
    if trains[selected_train].route.nil?
      puts 'Назначьте маршрут поезду!'
    else
      puts "В какую сторону едем?\n1. Вперед\n2. Назад"
      dir_choice = gets.to_i
      case dir_choice
      when 1
        trains[selected_train].move_forward
        puts "Поезд на станции #{trains[selected_train].current_station.name}"
      when 2
        trains[selected_train].move_back
        puts "Вы на станции #{trains[selected_train].current_station.name}"
      end
    end
  end
end

def station_review(stations)
  if stations.empty?
    puts "Создайте станцию!"
  else
    puts "Выберите станцию из списка: "
    station_list_read(stations)
    selected_station = gets.chomp.to_i - 1
    puts "Cтанция #{stations[selected_station].name}:
    #{stations[selected_station].count_by('cargo')} грузовых поездов
    #{stations[selected_station].count_by('passenger')} пассажирских поездов"
  end
end

def refresh_route(trains, selected_route)
  for train in trains
    train.take_route(selected_route) if train.route == selected_route
  end
end
