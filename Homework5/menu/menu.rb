# frozen_string_literal: true

require_relative 'menu_node'

class Menu

  def initialize(jack)
    @jack = jack
    root = MenuNode.new('root')
    @selected = root

    stations_man = root.add_child(MenuNode.new('Stations management'))
    stations_man.add_child(MenuNode.new('Create station', :create_station))
    stations_man.add_child(MenuNode.new('Rename station', :rename_station))

    route_man = root.add_child(MenuNode.new('Routes management'))
    route_man.add_child(MenuNode.new('Create route', :create_route))
    route_man.add_child(MenuNode.new('Add station to route', :add_station_to_route))
    route_man.add_child(MenuNode.new('Remove station from route', :remove_station_from_route))

    train_man = root.add_child(MenuNode.new('Train management'))
    train_man.add_child(MenuNode.new('Create train', :create_train))
    train_man.add_child(MenuNode.new('Attach wagon to train', :attach_wagon))
    train_man.add_child(MenuNode.new('Detach wagon from train', :detach_wagon))
    train_man.add_child(MenuNode.new('Set route to train', :set_route_to_train))
    train_man.add_child(MenuNode.new('Move train', :move_train))

    report = root.add_child(MenuNode.new('Reports'))
    report.add_child(MenuNode.new('Stations list', :show_stations))
    report.add_child(MenuNode.new('Trains list at station', :show_trains_at_station))
    report.add_child(MenuNode.new('Routes list', :show_routes))
    report.add_child(MenuNode.new('Trains list', :show_trains))

    root
  end

  def menu_select
    catch(:exit) do
      loop do
        puts ''
        show(@selected.nodes)
        command = get_input('Please, select action: ', 'Invalid selection!', @selected.nodes.length)

        if command == 'q'
          throw :exit if @selected.parent.nil?
          @selected = @selected.parent
          next
        end

        new_node = @selected.nodes[command - 1]
        if new_node.children?
          @selected = new_node
        else
          @jack.send new_node.method
        end
      end
    end
  end

  private

  def show(items, clear: false)
    system('clear') if clear
    items.each_with_index do |item, index|
      puts " #{index + 1} - #{item.name}"
    end
    puts "\n q - Exit"
  end

  def get_input(msg, err_msg, max)
    begin
      print msg
      result = gets.chomp
      return result if result == 'q'

      result = Integer(result)
      raise ArgumentError if result.negative? || result > max
    rescue TypeError, ArgumentError
      puts err_msg
      retry
    end
    result
  end
end
