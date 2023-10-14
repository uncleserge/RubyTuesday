# frozen_string_literal: true

require_relative './modules/instance_counter'
require_relative './modules/validator'
require_relative './trains/train'
require_relative './route'

#  Класс Station (Станция):
#     Имеет название, которое указывается при ее создании
#     Может принимать поезда (по одному за раз)
#     Может возвращать список всех поездов на станции, находящиеся в текущий момент
#     Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
#     Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  include InstanceCounter
  include Validator

  attr_reader :trains, :title

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    validate!
    register_instance
    @trains = []
    @@stations << self
  end

  def rename(title)
    # raise ArgumentError, 'Station title is null or empty.' if title.nil? || title == ''
    check_null_or_empty! title

    @title = title
  end

  def in(train)
    # raise ArgumentError, 'Train object is null.' if train.nil?
    # raise TypeError, 'Argument is not type of Train.' unless train.is_a?(Train)
    check_null_or_train(train)

    @trains << train
  end

  def out(train)
    # raise ArgumentError, 'Train object is null.' if train.nil?
    # raise TypeError, 'Argument is not type of Train.' unless train.is_a?(Train)
    check_null_or_train(train)

    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.filter { |train| train.type == type }
  end

  def trains_quantity_by_type(type)
    @trains.filter { |train| train.type == type }.size
  end

  def each_train(&block)
    @trains.each_with_index { |train, index| block.call(train, index) }
  end
end
