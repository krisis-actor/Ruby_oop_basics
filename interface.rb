require_relative 'train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'

class Interface

  def initialize

    @user_created_stations = []
    @user_created_trains = []
    @user_created_routes = []
    @menu = 
    "Выберите действие:
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
  
  private
  #Пользователь может пользоваться программой, без внепланового вызова методов класса

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
        create_station(@user_created_stations)
      when 2
        create_p_train(@user_created_trains)
      when 3
        create_c_train(@user_created_trains)
      when 4
        create_route(@user_created_routes,@user_created_stations)
      when 5
        edit_route(@user_created_routes,@user_created_stations)
      when 6
        set_route_to_train(@user_created_trains,@user_created_routes)
      when 7
        add_wagon(@user_created_trains)
      when 8
        del_wagon(@user_created_trains)
      when 9
        move_train(@user_created_trains)
      when 10
        station_review(@user_created_stations)
      else 
        puts "Мисклик!"
    end
  end

  def create_station(user_created_stations)
    puts "Введите название станции: "
    new_station = Station.new(gets.chomp.capitalize)
    stations_names = []
    user_created_stations.each { |station| stations_names << station.name }
    if stations_names.include? new_station.name
      puts "Станция с таким названием уже создана!"
    else
      user_created_stations << new_station
      puts "Станция #{new_station.name} создана!"
    end
  end
  
  def create_p_train(user_created_trains)
    puts "Введите номер поезда"
    new_train = PassengerTrain.new(gets.chomp.capitalize)
    train_numbers = []
    user_created_trains.each { |train| train_numbers << train.number }
    if train_numbers.include? new_train.number
      puts "Поезд с таким номером уже существует!"
    else
      user_created_trains << new_train
      puts "Поезд #{new_train.number} создан!"
    end
  end
  
  def create_c_train(user_created_trains)
    puts "Введите номер поезда"
    new_train = CargoTrain.new(gets.chomp.capitalize)
    train_numbers = []
    user_created_trains.each { |train| train_numbers << train.number }
    if train_numbers.include? new_train.number
      puts "Поезд с таким номером уже существует!"
    else
      user_created_trains << new_train
      puts "Поезд #{new_train.number} создан!"
    end
  end
  
  def create_route(user_created_routes,user_created_stations)
    if user_created_stations.size >= 2
      puts "Введите номер маршрута"
      route_number = gets.chomp.upcase
      puts "Выберите начальную станцию: "
      station_list_read(user_created_stations)
      selected_station_1 = user_created_stations[gets.chomp.to_i - 1]
      puts "Выберите конечную станцию: "
      station_list_read(user_created_stations)
      selected_station_2 = user_created_stations[gets.chomp.to_i - 1]
      if selected_station_1 != selected_station_2
        new_route = Route.new(route_number,selected_station_1,selected_station_2)
        user_created_routes << new_route
        puts "Маршрут создан!"
      else
        puts "Начальная и конечная станция должны отличаться!"
      end
    else
      puts "Требуется минимум 2 станции для создания маршрута!"
    end
    
  end
  
  def edit_route(user_created_routes,user_created_stations)
    puts "Выберите маршрут: "
    route_list_read(user_created_routes)
    selected_route = user_created_routes[gets.to_i - 1]
    puts "1. Добавить станцию\n2. Удалить станцию"
    user_choice = gets.to_i
    case user_choice
      when 1
        user_created_stations_filtered = user_created_stations - 
          selected_route.route
        if user_created_stations_filtered.empty?
          puts "Создайте станцию!"
        else
          station_list_read(user_created_stations_filtered)
          selected_station = user_created_stations_filtered[gets.to_i - 1]
          selected_route.add_passing_station(selected_station)
          puts "Станция добавлена!"
        end
      when 2
        if selected_route.route.size >=3
          puts "Выберите промежуточную станцию для удаления: "
          station_list_read(selected_route.route[1..-2])
          selected_station = selected_route.route[gets.to_i - 1]
          selected_route.del_passing_station(selected_station)
          puts "Станция удалена!"
        else
          puts "Нет станций для удаления!"
        end
      end
  end

  def station_list_read(user_created_stations)
    i = 0
    user_created_stations.each do
      |station| puts "#{i += 1}. #{station.name}"
    end
  end
  
  def train_list_read(user_created_trains)
    i = 0
    user_created_trains.each do
      |train| puts "#{i += 1}. #{train.number}"
    end
  end
  
  def route_list_read(user_created_routes)
    i = 0
    user_created_routes.each do
      |route| puts "#{i += 1}. #{route.number}"
    end
  end
  
  def set_route_to_train(user_created_trains,user_created_routes)
    if user_created_trains.empty?
      puts "Нет созданных поездов"
    else
      puts "Выберите поезд из списка"
      train_list_read(user_created_trains)
      selected_train = user_created_trains[gets.to_i - 1]
    end
  
    if user_created_routes.empty?
      puts "Нет созданных маршрутов"
    else
      puts "Выберите маршрут из списка"
      route_list_read(user_created_routes)
      selected_route = user_created_routes[gets.to_i - 1]
      if selected_route == selected_train.route
        puts "Поезду уже присвоен такой маршрут!"
      else
        selected_train.take_route(selected_route)
        puts "Маршрут присвоен!"
      end
    end
  end
  
  def add_wagon(user_created_trains)
    if user_created_trains.empty?
      puts "Создайте поезд!"
    else
      puts "Выберите поезд: "
      train_list_read(user_created_trains)
      selected_train = gets.chomp.to_i - 1
      if user_created_trains[selected_train].type == 'passenger'
        wagon = PassengerWagon.new
        user_created_trains[selected_train].attache_train(wagon)
        puts "Вагон добавлен!"
      else
        wagon = CargoWagon.new
        user_created_trains[selected_train].attache_train(wagon)
        puts "Вагон добавлен!"
      end
    end
  end
  
  def del_wagon(user_created_trains)
    if user_created_trains.empty?
      puts "Создайте поезд!"
    else
      puts "Выберите поезд"
      train_list_read(user_created_trains)
      selected_train = gets.to_i - 1
      if user_created_trains[selected_train].detache_train
        puts "Вагон отцеплен!"
      else
        puts "У состава больше нет вагонов!"
      end
    end
  end
  
  def move_train(user_created_trains)
    if user_created_trains.empty?
      puts "Создайте поезд!"
    else
      puts "Выберите поезд"
      train_list_read(user_created_trains)
      selected_train = gets.to_i - 1
      if user_created_trains[selected_train].route.nil?
        puts "Назначьте маршрут поезду!"
      else
        puts "В какую сторону едем?\n1. Вперед\n2. Назад"
        dir_choice = gets.to_i
        case dir_choice
          when 1
            user_created_trains[selected_train].move_forward
            puts "Поезд на станции #{user_created_trains[selected_train].current_station.name}"
          when 2
            user_created_trains[selected_train].move_back
            puts "Вы на станции #{user_created_trains[selected_train].current_station.name}"
        end
      end
    end 
  end
  
  def station_review(user_created_stations)
    if user_created_stations.empty?
      puts "Создайте станцию!"
    else
      puts "Выберите станцию из списка: "
      station_list_read(user_created_stations)
      selected_station = gets.chomp.to_i - 1
      puts "Cтанция #{user_created_stations[selected_station].name}:
      #{user_created_stations[selected_station].count_by('cargo')} грузовых поездов
      #{user_created_stations[selected_station].count_by('passenger')} пассажирских поездов"
    end
  end

end
