# frozen_string_literal: true

# Класс Train (Поезд):
#     Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
#       эти данные указываются при создании экземпляра класса
#     Может набирать скорость
#     Может возвращать текущую скорость
#     Может тормозить (сбрасывать скорость до нуля)
#     Может возвращать количество вагонов
#     Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
#       метод просто увеличивает или уменьшает количество вагонов).
#       Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
#     Может принимать маршрут следования (объект класса Route).
#     При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
#     Может перемещаться между станциями, указанными в маршруте.
#       Перемещение возможно вперед и назад, но только на 1 станцию за раз.
#     Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
class Train
  #  TYPE = [CARGO = 1, PASSENGER = 2].freeze

  attr_reader :number, :wagons, :route
  attr_accessor :speed

  def initialize(number)
    raise ArgumentError, 'Train number is null or empty.' if number.nil?

    @number = number
    @wagons = []
    @speed = 0
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    raise StandardError, "'It's impossible. The train is moving." unless @speed.zero?
    raise StandardError, 'Incorrect type of wagon' unless type_correct?(wagon.type)

    attach_wagon!(wagon)
  end

  def detach_wagon
    raise StandardError, "'It's impossible. The train is moving." unless @speed.zero?
    raise StandardError, 'The train has no attached wagons' if @wagons.empty?

    wagons.pop
  end

  def route=(route)
    raise ArgumentError, 'Route object is null.' if route.nil?
    raise TypeError, 'Argument is not type of Route.' unless route.is_a?(Route)

    @route = route
    route.first_station.in(self)
    @station_index = 0
  end

  # Перемещение вперед
  def forward
    raise StandardError, 'Train has no route' if @route.nil?

    if @route.first_station != @route.last_station && @route.last_station.trains.include?(self)
      raise StandardError, 'Train at the last station of the route'
    end

    @route.stations[@station_index].out(self)
    @route.stations[@station_index += 1].in(self)
  end

  # Перемещение назад
  def backward
    raise StandardError, 'Train has no route' if @route.nil?

    if @route.first_station != @route.last_station && @route.first_station.trains.include?(self)
      raise StandardError, 'Train at the first station of the route'
    end

    @route.stations[@station_index].out(self)
    @route.stations[@station_index -= 1].in(self)
  end

  #  Возвращает текущую станцию на основе маршрута или nil
  def current_station
    @route.stations[@station_index] unless @route.nil?
  end

  #  Возвращает следующую станцию на основе маршрута или nil
  def next_station
    route.stations[@station_index + 1] unless @route.nil?
  end

  #  Возвращает предыдущую станцию на основе маршрута или nil
  def prev_station
    return nil if @route.nil? || @station_index.zero?

    route.stations[@station_index - 1]
  end

  private

  def attach_wagon!(wagon)
    @wagons << wagon
  end

  def type_correct?(type)
    type == @type
  end
end

