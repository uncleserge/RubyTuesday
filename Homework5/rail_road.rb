# frozen_string_literal: true

require_relative 'user_input'
require_relative 'station'
require_relative 'route'
require_relative './trains/cargo_train'
require_relative './trains/passenger_train'
require_relative './wagons/cargo_wagon'
require_relative './wagons/passenger_wagon'
require_relative './menu/menu'
require_relative './menu/menu_node'

DATA_FILE = './railroad.data'

class RailRoad
  def initialize
    @menu = Menu.new(self)
    @stations = Station.all
    @trains = Train.all
    @routes = []
    @types = %i[cargo passenger]
  end

  def run
    load_data
    @menu.menu_select
    store_data
  end

  def load_data
    return unless File.exist? DATA_FILE

    data = Marshal.load(File.read(DATA_FILE))

    data[:stations].each { |st| @stations << st }
    data[:trains].each { |tr| @trains << tr }
    @routes = data[:routes]
  end

  def store_data
    data = { stations: @stations, routes: @routes, trains: @trains }
    File.open(DATA_FILE, 'w') do |f|
      f.write(Marshal.dump(data))
    end
  end

  def create_station
    name_station = UI.get_str("Station's name:", 'Please, enter non empty value.')
    station = Station.new(name_station)
    @stations << station
    puts "Station #{station.title} created."
    show_stations
  rescue => e
    puts e.message
    retry
  end
  
  def rename_station
    show_stations
    index = UI.get_num('Enter station index: ', 'Please enter correct numeric value.', @stations.length)
    index -= 1
    begin
      new_name = UI.get_str('Station new name:', 'Please, enter non empty value.')
      @stations[index].rename(new_name)
      puts 'Station renamed'
      show_stations
    rescue => e
      puts e.message
      retry
    end
  end

  def create_train
    show_types
    index = UI.get_num('Select train type: ', 'Please enter correct numeric value.', @types.length)
    index -= 1
    type = @types[index]
    train_num = UI.get_str('Enter train number:', 'Please, enter non empty value.')
    case type
    when :cargo
      @trains << CargoTrain.new(train_num)
    when :passenger
      @trains << PassengerTrain.new(train_num)
    else
      raise StandardError, 'Incorrect type.'
    end
    show_trains
  rescue => e
    puts e.message
    retry
  end

  def attach_wagon
    return puts("There aren't trains in system") if @trains.empty?

    show_trains
    index = UI.get_num('Select train index: ', 'Please enter correct numeric value.', @trains.length)
    index -= 1
    case @trains[index].type
    when :cargo
      @trains[index].attach_wagon(CargoWagon.new)
    when :passenger
      @trains[index].attach_wagon(PassengerWagon.new)
    else
      raise StandardError, 'Incorrect type.'
    end
    puts("Wagon to train #{@trains[index].number} attached")
    show_train(@trains[index])
  rescue => e
    puts e.message
  end

  def detach_wagon
    return puts("There aren't trains in system.") if @trains.empty?

    show_trains
    index = UI.get_num('Select train index: ', 'Please enter correct numeric value.', @trains.length)
    index -= 1
    @trains[index].detach_wagon
  rescue => e
    puts e.message
  end

  def set_route_to_train
    return puts("There aren't trains in system.") if @trains.empty?

    show_trains
    index_tr = UI.get_num('Select train index: ', 'Please enter correct numeric value.', @trains.length)
    index_tr -= 1

    puts("Train #{@trains[index_tr].number}")
    return puts("There aren't routes in system.") if @routes.empty?

    show_routes
    index_ro = UI.get_num('Select route index: ', 'Please enter correct numeric value.', @routes.length)
    index_ro -= 1

    @trains[index_tr].route = @routes[index_ro]
    puts("Route set to train #{@trains[index_tr].number}")
    show_train(@trains[index_tr])
  rescue => e
    puts e.message
  end
  
  def move_train
    return puts("There aren't trains in system.") if @trains.empty?

    trains_w_route = @trains.reject{ |train| train.route.nil? }
    return puts('No trains with route. ') if trains_w_route.empty?

    show_trains_collection trains_w_route
    index = UI.get_num('Select train index: ', 'Please enter correct numeric value.', trains_w_route.length)
    index -= 1

    %i[backward forward].each_with_index { |type, index| puts("#{index + 1} - #{type.to_s}  ") }
    puts ''
    index_move = UI.get_num('Select direction: ', 'Please enter correct numeric value.', 2)
    index_move -= 1
    case index_move
    when 0
      trains_w_route[index].backward
    when 1
      trains_w_route[index].forward
    else
      raise StandardError, 'Incorrect value'
    end
    puts("Train successfully moved to station #{trains_w_route[index].current_station.title}")
  rescue => e
    puts e.message
  end

  def create_route
    show_stations
    index_first = UI.get_num('Enter first station index: ', 'Please enter correct numeric value.', @stations.length)
    index_first -= 1
    index_last = UI.get_num('Enter last station index: ', 'Please enter correct numeric value.', @stations.length)
    index_last -= 1
    @routes << Route.new(@stations[index_first], @stations[index_last])
    puts('Route added.')
    show_routes
  rescue => e
    puts e.message
    retry
  end

  def add_station_to_route
    return puts("There aren't routes in system.") if @routes.empty?

    show_routes
    index = UI.get_num('Select route index: ', 'Please enter correct numeric value.', @routes.length)
    index -= 1
    show_stations
    puts ''
    index_st = UI.get_num('Enter station index: ', 'Please enter correct numeric value.', @stations.length)
    index_st -= 1
    @routes[index].add_station(@stations[index_st])
    puts("Station to route #{index + 1} added")
    show_route(@routes[index])
  rescue => e
    puts e.message
  end

  def remove_station_from_route
    return puts("There aren't routes in system.") if @routes.empty?

    show_routes
    index = UI.get_num('Select route index: ', 'Please enter correct numeric value.', @routes.length)
    index -= 1
    show_route(@routes[index])
    puts ''
    index_st = UI.get_num('Enter station index to delete: ', 'Please enter correct numeric value.', @stations.length)
    index_st -= 1
    @routes[index].delete_station(index_st)
    puts("Station from route #{index + 1} deleted")
    show_route(@routes[index])
  rescue => e
    puts e.message
  end

  def show_types
    @types.each_with_index { |type, index| print("#{index + 1} - #{type.to_s}  ") }
    puts ''
  end

  def show_stations
    return puts('No stations') if Station.all.empty?

    puts('Stations(trains quantity):')
    Station.all.each_with_index do |st, index|
      print("#{index + 1} - #{st.title} (#{st.trains.length})   ")
      puts '' if ((index + 1) % 4).zero?
    end

    puts ''
  end

  def show_route(route)
    route = route.stations.each_with_index.map { |st, index| "\##{index + 1}-#{st.title}" }
    puts(route.join(' => '))
  end

  def show_routes
    return puts('No routes') if @routes.empty?

    puts('Routes:')
    @routes.each_with_index do |route, index|
      print(" #{index + 1} - ")
      show_route(route)
    end
  end

  def show_train(train)
    puts("#{train.type.to_s} train # #{train.number} have #{train.wagons.length} wagon(s) ")
    return if train.route.nil?

    print '    Current route: '
    show_route(train.route)
    puts("    Current station: #{train.current_station.title}")
  end

  def show_trains
    show_trains_collection @trains
  end

  def show_trains_collection(trains)
    return puts('No trains') if trains.empty?

    puts('Trains:')
    trains.each_with_index do |train, index|
      print("#{index + 1} - ")
      show_train(train)
    end
  end

  def show_trains_at_station
    show_stations
    index = UI.get_num('Enter station index: ', 'Please enter correct numeric value.', @stations.length)
    index -= 1
    puts("Station #{@stations[index].title} :")
    @stations[index].trains.each_with_index do |train, index| 
      puts "#{index} - #{train.type.to_s} train # #{train.number} have #{train.wagons.length} wagon(s)"
      unless train.route.nil?
        print '    Route: '
        show_route train.route
      end
    end
  end

end
