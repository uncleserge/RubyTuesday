# frozen_string_literal: true

require_relative './station'
require_relative './modules/validator'

# Класс Route (Маршрут):
#
#     Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
#     Может добавлять промежуточную станцию в список
#     Может удалять промежуточную станцию из списка
#     Может выводить список всех станций по-порядку от начальной до конечной
class Route
  include Validator

  def initialize(first, last)
    @stations = [first, last]
    validate!
  end

  def first_station
    @stations[0]
  end

  def last_station
    @stations[-1]
  end

  def add_station(station)
    check_null_or_station station

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
