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

# Класс RailRoad содержит методы для моделирования управления Ж/Д
#
class RailRoad
  DATA_FILE = './railroad.data'
  MAX_INT = (2**(['foo'].pack('p').size * 8) - 1)

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
    puts "Station #{station.title} created."
    show_stations
  rescue StandardError => e
    puts e.message
    retry
  end

  def rename_station
    show_stations
    index = UI.get_num('Enter station index: ', 'Please enter correct numeric value.', @stations.length)
    index -= 1
    new_name = UI.get_str('Station new name:', 'Please, enter non empty value.')
    @stations[index].rename(new_name)
    puts 'Station renamed'
    show_stations
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_train
    show_types
    index = UI.get_num('Select train type: ', 'Please enter correct numeric value.', @types.length)
    index -= 1
    type = @types[index]
    train_num = UI.get_str('Enter train number in XXXXX or XXX-XX format, where X is digit or letter: ',
                           'Please, enter correct non empty value.')
    case type
    when :cargo
      CargoTrain.new(train_num)
    when :passenger
      PassengerTrain.new(train_num)
    else
      raise StandardError, 'Incorrect type.'
    end
    show_trains
  rescue StandardError => e
    puts e.message
    retry
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
  rescue StandardError => e
    puts e.message
  end

  def move_train
    return puts("There aren't trains in system.") if @trains.empty?

    trains_w_route = @trains.reject { |train| train.route.nil? }
    return puts('No trains with route. ') if trains_w_route.empty?

    show_trains_collection trains_w_route
    index = UI.get_num('Select train index: ', 'Please enter correct numeric value.', trains_w_route.length)
    index -= 1

    %i[backward forward].each_with_index { |type, ind| puts("#{ind + 1} - #{type}  ") }
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
  rescue StandardError => e
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
  # rescue StandardError => e
  #   puts e.message
  #   retry
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
  rescue StandardError => e
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
  rescue StandardError => e
    puts e.message
  end

  def attach_wagon
    return puts("There aren't trains in system") if @trains.empty?

    show_trains
    index = UI.get_num('Select train index: ', 'Please enter correct numeric value.', @trains.length)
    index -= 1
    case @trains[index].type
    when :cargo
      wagon_max_volume = UI.get_num('Enter max volume value: ', 'Please enter correct numeric value.', MAX_INT)
      @trains[index].attach_wagon(CargoWagon.new(wagon_max_volume))
    when :passenger
      wagon_max_seats = UI.get_num('Enter max wagon seats value: ', 'Please enter correct numeric value.', MAX_INT)
      @trains[index].attach_wagon(PassengerWagon.new(wagon_max_seats))
    else
      raise StandardError, 'Incorrect type.'
    end
    puts("Wagon to train #{@trains[index].number} attached")
    show_train(@trains[index])
  rescue StandardError => e
    puts e.message
  end

  def detach_wagon
    trains = @trains.reject { |train| train.wagons.empty? }
    return puts("There aren't trains with wagons in the system.") if trains.empty?

    show_trains_collection trains
    index = UI.get_num('Select train index: ',
                       'Please enter correct numeric value.',
                       trains.length)
    index -= 1
    show_train trains[index]
    show_wagons trains[index]
    w_index = UI.get_num('Select wagon index: ',
                         'Please enter correct numeric value.',
                         trains[index].wagons.length)
    w_index -= 1
    @trains[index].detach_wagon w_index
    show_train trains[index]
    show_wagons trains[index]
  rescue StandardError => e
    puts e.message
  end

  def fill_cargo_wagon
    trains = @trains.filter { |train| train.type == :cargo }
    return puts("There aren't cargo wagon because there aren't cargo trains in system.") if trains.empty?

    show_trains_with_wagons trains
    wagon_id = UI.get_str('Enter wagon identifier: ', 'Please, enter non empty value.')
    train = trains.find(proc { nil }) { |train| !!train.wagon(wagon_id) }
    raise StandardError, "No wagon with identifier #{wagon_id}" if train.nil?

    wagon = train.wagon(wagon_id)
    show_wagon wagon
    volume = UI.get_num("\nEnter volume you want to add: ",
                        "Please enter correct numeric non-zero value no more than #{wagon.total_volume}.",
                        wagon.total_volume)
    wagon.fill_volume volume
    puts "#{volume} added to wagon #{wagon.id}"
    show_wagon wagon
    puts ''
  rescue StandardError => e
    puts e.message
  end

  def take_seat_at_wagon
    trains = @trains.filter { |train| train.type == :passenger }
    return puts("There aren't passenger wagon because there aren't passenger trains in system.") if trains.empty?

    show_trains_with_wagons trains
    wagon_id = UI.get_str('Enter wagon identifier: ', 'Please, enter non empty value.')
    train = trains.find(proc { nil }) { |train| !(!train.wagon(wagon_id)) }
    raise StandardError, "No wagon with identifier #{wagon_id}" if train.nil?

    wagon = train.wagon(wagon_id)
    show_wagon wagon
    wagon.take_seat
    puts "Seat took at wagon #{wagon.id}"
    show_wagon wagon
    puts ''
  rescue StandardError => e
    puts e.message
  end

  def show_types
    @types.each_with_index { |type, index| print("#{index + 1} - #{type}  ") }
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
    puts("#{train.type.to_s.capitalize} train # #{train.number} have #{train.wagons.length} wagon(s) ")
  end

  def show_trains
    show_trains_collection @trains
  end

  def show_trains_collection(trains, &block)
    return puts('No trains') if trains.empty?

    puts('Trains:')
    trains.each_with_index do |train, index|
      print("#{index + 1} - ")
      show_train train
      unless train.route.nil?
        print '    Route: '
        show_route train.route
        puts("    Current station: #{train.current_station.title}") unless train.current_station.nil?
      end
      yield(train) if block_given?
    end
  end

  def show_all_trains_with_wagons
    show_trains_with_wagons @trains
  end

  def show_trains_with_wagons(trains)
    show_trains_collection trains do |train|
      show_wagons(train)
    end
  end

  def show_wagon(wagon)
    case wagon.type
    when :cargo
      print "#{wagon.id} (#{wagon.volume || 0}/#{wagon.total_volume || 0}).  "
    when :passenger
      print "#{wagon.id} (#{wagon.seats || 0}/#{wagon.total_seats || 0}}).  "
    else
      raise StandardError, 'No correct information for this type of wagon.'
    end
  end

  def show_wagons(train)
    return puts('Train have no wagons') if train.wagons.empty?

    print('    Wagons: ')
    train.each_wagon do |wagon, i|
      print "#{i} - "
      show_wagon wagon
    end
    puts ''
  end

  def show_trains_at_station
    show_stations
    index = UI.get_num('Enter station index: ', 'Please enter correct numeric value.', @stations.length)
    index -= 1
    puts("Station #{@stations[index].title} :")
    return puts('No trains at station') if @stations[index].trains.empty?

    @stations[index].each_train do |train, i|
      print "#{i} - "
      show_train train
      next if train.wagons.empty?

      show_wagons train
    end
  end
end
