# frozen_string_literal: true

# Класс Route (Маршрут):
#
#     Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
#     Может добавлять промежуточную станцию в список
#     Может удалять промежуточную станцию из списка
#     Может выводить список всех станций по-порядку от начальной до конечной
class Route
  attr_reader :first_station, :last_station

  def initialize(first, last)
    raise ArgumentError, 'Station object is null.' if first.nil?
    raise TypeError, 'Argument is not type of Station.' unless first.is_a?(Station)
    raise ArgumentError, 'Station object is null.' if last.nil?
    raise TypeError, 'Argument is not type of Station.' unless last.is_a?(Station)

    @first_station = first
    @last_station = last
    @stations = []
  end

  def add_station(station)
    raise ArgumentError, 'Station object is null.' if station.nil?
    raise TypeError, 'Argument is not type of Station.' unless station.is_a?(Station)

    @stations << station
  end

  def delete_station(station)
    @stations.delete(station)
  end

  def stations
    [@first_station, @stations, @last_station].flatten
  end
end
