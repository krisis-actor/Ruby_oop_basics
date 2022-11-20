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
    10. Просмотреть список станций и список поездов на станции
    11. Вывести список поездов на станции в формате Номер/Тип/Кол-во вагонов
    12. Вывести список вагонов поезда в формате Номер вагона/Тип/Кол-во свободных(ого) мест(объема)/Кол-во занятых(ого) мест(объема)
    13. Занять место/объем в вагоне"
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
      create_station
    when 2
      create_p_train
    when 3
      create_c_train
    when 4
      create_route
    when 5
      edit_route
    when 6
      set_route_to_train
    when 7
      add_wagon
    when 8
      del_wagon
    when 9
      move_train
    when 10
      station_review
    when 11
      station_train_info
    when 12
      train_wagon_info
    when 13
      reserve_wagon
    else
      puts 'Мисклик!'
    end
  end
end

def create_station
  puts 'Введите название станции:'
  station = Station.new(gets.chomp.capitalize)
  puts "Станция #{station.name} создана!"
rescue RuntimeError => e
  puts e.to_s
  retry
end

def create_p_train
  puts 'Введите номер поезда'
  p_train = PassengerTrain.new(gets.chomp.upcase)
  puts "Поезд #{p_train.number} создан!"
rescue RuntimeError => e
  puts e.to_s
  retry
end

def create_c_train
  puts 'Введите номер поезда'
  c_train = CargoTrain.new(gets.chomp.upcase)
  puts "Поезд #{c_train.number} создан!"
rescue RuntimeError => e
  puts e.to_s
  retry
end

def create_route
  if Station.all.size >= 2
    puts 'Введите номер маршрута и выберите начальную и конечную станции'
    num = gets.chomp.upcase
    station_list_read
    station1 = Station.all[gets.chomp.to_i - 1]
    station2 = Station.all[gets.chomp.to_i - 1]
    route = Route.new(num, station1, station2)
    puts "Маршрут №#{route.number} создан!"
  else
    puts 'Требуется минимум 2 станции для создания маршрута!'
  end
rescue RuntimeError => e
  puts e.to_s
  retry unless e.to_s == 'Начальная и конечная станции должны отличаться!'
end

def edit_route
  puts 'Выберите маршрут:'
  route_list_read
  selected_route = Route.all[gets.to_i - 1]
  puts "1. Добавить станцию\n2. Удалить станцию"
  user_choice = gets.chomp
  case user_choice
  when '1'
    stations_add = Station.all - selected_route.route
    if stations_add.empty?
      puts 'Создайте станцию!'
    else
      stations_add.each_with_index do |station, i|
        puts "#{i + 1}. #{station.name}"
      end
      selected_station = stations_add[gets.to_i - 1]
      selected_route.add_passing_station(selected_station)
      puts 'Станция добавлена!'
      refresh_route(selected_route)
    end
  when '2'
    if selected_route.route.size >= 3
      puts 'Выберите промежуточную станцию для удаления: '
      selected_route.route[1..-2].each_with_index do |station, i|
        puts "#{i + 1}. #{station.name}"
      end
      selected_station = selected_route.route[gets.to_i - 1]
      selected_route.del_passing_station(selected_station)
      puts 'Станция удалена!'
      refresh_route(selected_route)
    else
      puts 'Нет станций для удаления!'
    end
  end
end

def station_list_read
  Station.all.each_with_index do |station, i|
    puts "#{i + 1}. #{station.name}"
  end
end

def train_list_read
  Train.all.each_with_index do |train, i|
    puts "#{i += 1}. #{train.number}"
  end
end

def route_list_read
  Route.all.each_with_index do |route, i|
    puts "#{i + 1}. #{route.number} #{route.route[0].name} - #{route.route[-1].name}"
  end
end

def set_route_to_train
  if Train.all.empty?
    puts 'Нет созданных поездов'
  else
    puts 'Выберите поезд из списка'
    train_list_read
    selected_train = Train.all[gets.to_i - 1]
  end

  if Route.all.empty?
    puts 'Нет созданных маршрутов'
  else
    puts 'Выберите маршрут из списка'
    route_list_read
    selected_route = Route.all[gets.to_i - 1]
    if selected_route == selected_train.route
      puts 'Поезду уже присвоен такой маршрут!'
    else
      selected_train.take_route(selected_route)
      puts 'Маршрут присвоен!'
    end
  end
end

def add_wagon
  if Train.all.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд:'
    train_list_read
    user_choice = gets.chomp.to_i - 1
    if Train.all[user_choice].type == 'passenger'
      puts 'Введите количество мест в вагоне:'
      wagon = PassengerWagon.new(gets.chomp.to_i)
    else
      puts 'Введите объем вагона, м3:'
      wagon = CargoWagon.new(gets.chomp.to_i)
    end
  end
  Train.all[user_choice].attache_train(wagon)
  puts 'Вагон добавлен!'
end

def del_wagon
  if Train.all.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд:'
    train_list_read
    selected_train = Train.all[gets.to_i - 1]
    if !selected_train.wagons.empty?
      selected_train.detache_train
      puts 'Вагон отцеплен!'
    else
      puts 'У состава нет вагонов!'
    end
  end
end

def move_train
  if Train.all.empty?
    puts 'Создайте поезд!'
  else
    puts 'Выберите поезд:'
    train_list_read
    selected_train = Train.all[gets.to_i - 1]
    if selected_train.route.nil?
      puts 'Назначьте маршрут поезду!'
    else
      puts "В какую сторону едем?\n1. Вперед\n2. Назад"
      dir_choice = gets.to_i
      case dir_choice
      when 1
        selected_train.move_forward
        puts "Поезд на станции #{selected_train.current_station.name}"
      when 2
        selected_train.move_back
        puts "Вы на станции #{selected_train.current_station.name}"
      end
    end
  end
end

def station_review
  if Station.all.empty?
    puts 'Создайте станцию!'
  else
    puts 'Выберите станцию из списка:'
    station_list_read
    selected_station = Station.all[gets.chomp.to_i - 1]
    puts "Cтанция #{selected_station.name}:
    #{selected_station.count_by('cargo')} грузовых поездов
    #{selected_station.count_by('passenger')} пассажирских поездов"
  end
end

def station_train_info
  puts 'Выберите станцию'
  station_list_read
  Station.all[gets.chomp.to_i - 1].train_info do |train|
    puts "Номер поезда: #{train.number}\nТип: #{train.type}\nКол-во вагонов: #{train.wagons.size}"
  end
end

def train_wagon_info
  puts 'Выберите поезд'
  train_list_read
  selected_train = Train.all[gets.chomp.to_i - 1]
  if !selected_train.wagons.empty?
    selected_train.wagon_info do |wagon, i|
      if wagon.type == 'passenger'
        puts "Номер вагона: #{i}\nТип вагона: #{wagon.type}\nКол-во свободных мест: #{wagon.free_seats}\nКол-во занятых мест: #{wagon.taken_seats}"
      else
        puts "Номер вагона: #{i}\nТип вагона: #{wagon.type}\nСвободный объем: #{wagon.free_volume}\nЗанятый объем: #{wagon.taken_volume}"
      end
    end
    selected_train
  else
    puts 'У поезда нет вагонов!'
  end
end

def refresh_route(selected_route)
  Train.all.each { |train| train.take_route(selected_route) if train.route == selected_route }
end

def reserve_wagon
  selected_train = train_wagon_info
  return if selected_train.nil?

  puts 'Выберите вагон:'
  selected_train.wagons.each_with_index do |_wagon, i|
    puts "Вагон №#{i + 1}"
  end
  selected_wagon = selected_train.wagons[gets.to_i - 1]
  case selected_wagon.type
  when 'passenger'
    if selected_wagon.take_seat
      puts "Место занято.\nСвободных мест: #{selected_wagon.free_seats}"
    else
      puts 'Свободных мест нет'
    end
  when 'cargo'
    puts 'Введите нужный объем, м3'
    user_volume = gets.chomp.to_i
    if selected_wagon.take_volume(user_volume)
      puts "Объем занят.\nСвободный объем: #{selected_wagon.free_volume}"
    else
      puts 'Свободного объема нет'
    end
  end
end
