# frozen_string_literal: true

require_relative './station'
require_relative './modules/validation'

# Класс Route (Маршрут):
#
#     Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
#     Может добавлять промежуточную станцию в список
#     Может удалять промежуточную станцию из списка
#     Может выводить список всех станций по-порядку от начальной до конечной
class Route
  include Validation

  attr_reader :first_station, :last_station

  validate :first_station, :presence
  validate :first_station, :type, Station
  validate :last_station, :presence
  validate :last_station, :type, Station
  def initialize(first, last)
    @stations = [first, last]
    self.first_station = first
    self.last_station = last
    validate!
  end
  
  def add_station(station)
    check_null_or_type station, Station

    @stations.insert(-2, station)
  end

  def delete_station(index)
    raise StandardError, 'Route have only first and last stations' if @stations.length == 2

    @stations.delete_at(index)
    self.first_station = @stations.first
    self.last_station = @stations.last
  end

  def stations
    Array.new(@stations)
  end

  private

  attr_writer :first_station, :last_station

end
