# frozen_string_literal: true

require_relative 'station'

# Класс Route (Маршрут):
#
#     Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
#     Может добавлять промежуточную станцию в список
#     Может удалять промежуточную станцию из списка
#     Может выводить список всех станций по-порядку от начальной до конечной
class Route

  def initialize(first, last)
    raise ArgumentError, 'Station object is null.' if first.nil?
    raise TypeError, 'Argument is not type of Station.' unless first.is_a?(Station)
    raise ArgumentError, 'Station object is null.' if last.nil?
    raise TypeError, 'Argument is not type of Station.' unless last.is_a?(Station)

    @stations = [first, last]
  end

  def first_station
    @stations[0]
  end

  def last_station
    @stations[-1]
  end

  def add_station(station)
    raise ArgumentError, 'Station object is null.' if station.nil?
    raise TypeError, 'Argument is not type of Station.' unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def delete_station(index)
    raise StandardError, 'Route have only first and last stations' if @stations.length == 2

    @stations.delete_at(index)
  end

  def stations
    Array.new(@stations)
  end
end
