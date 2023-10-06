# frozen_string_literal: true

#  Класс Station (Станция):
#     Имеет название, которое указывается при ее создании
#     Может принимать поезда (по одному за раз)
#     Может возвращать список всех поездов на станции, находящиеся в текущий момент
#     Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
#     Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  attr_reader :trains, :title

  def initialize(title)
    raise ArgumentError, 'Station title is null or empty.' if title.nil? || title == ''

    @title = title
    @trains = []
  end

  def rename(title)
    raise ArgumentError, 'Station title is null or empty.' if title.nil? || title == ''

    @title = title
  end

  def in(train)
    raise ArgumentError, 'Train object is null.' if train.nil?
    raise TypeError, 'Argument is not type of Train.' unless train.is_a?(Train)

    @trains << train
  end

  def out(train)
    raise ArgumentError, 'Train object is null.' if train.nil?
    raise TypeError, 'Argument is not type of Train.' unless train.is_a?(Train)

    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.filter { |train| train.type == type }
  end

  def trains_quantity_by_type(type)
    @trains.filter { |train| train.type == type }.size
  end
end
